/**
 * Threads and thread-pool.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2012.
 * Copyright: Copyright (c) 2009-2011, David Simcha.
 * Copyright: Copyright Guillaume Piolat 2016.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly, Walter Bright, Alex Rønne Petersen, Martin Nowak, David Simcha, Guillaume Piolat
 *
 * EDIT: Thread rip-off.
 */
module dplug.core.thread;

import core.stdc.stdlib;
import core.stdc.stdio;

import dplug.core.nogc;

version(Posix)
    import core.sys.posix.pthread;
else version(Windows)
{
    import core.stdc.stdint : uintptr_t;
    import core.sys.windows.windef;
    import core.sys.windows.winbase;
    import core.thread;

    extern (Windows) alias btex_fptr = uint function(void*) ;
    extern (C) uintptr_t _beginthreadex(void*, uint, btex_fptr, void*, uint, uint*) nothrow @nogc;
}
else
    static assert(false, "Platform not supported");

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;

version(Darwin)
{
    extern(C) nothrow @nogc
    int sysctlbyname(const(char)*, void *, size_t *, void *, size_t);
}

//debug = threadPoolIsActuallySynchronous;


/// Legacy thread function
alias ThreadDelegate = void delegate() nothrow @nogc;

/// Thread function with user data, used eg. in thread pool.
alias ThreadDelegateUser = void delegate(void* userData) nothrow @nogc;


Thread makeThread(ThreadDelegate callback, size_t stackSize = 0) nothrow @nogc
{
    return Thread(callback, stackSize);
}

Thread makeThread(ThreadDelegateUser callback, size_t stackSize = 0, void* userData = null) nothrow @nogc
{
    return Thread(callback, stackSize, userData);
}

/// Optimistic thread, failure not supported
struct Thread
{
nothrow:
@nogc:
public:

    /// Create a thread with user data. Thread is not created until `start` has been called.
    ///
    /// Params:
    ///     callback  = The delegate that will be called by the thread.
    ///     stackSize = The thread stack size in bytes. 0 for default size.
    ///     userData  = a pointer to be passed to thread delegate
    ///
    /// Warning: It is STRONGLY ADVISED to pass a class member delegate (not a struct
    ///          member delegate) to have additional context.
    ///          Passing struct method delegates are currently UNSUPPORTED.
    ///
    this(ThreadDelegate callback, size_t stackSize = 0)
    {
        _stackSize = stackSize;
        _context = cast(CreateContext*) malloc(CreateContext.sizeof);
        _context.callback = callback;
        _context.callbackUser = null;
    }

    ///ditto
    this(ThreadDelegateUser callback, size_t stackSize = 0, void* userData = null)
    {
        _stackSize = stackSize;
        _context = cast(CreateContext*) malloc(CreateContext.sizeof);
        _context.callback = null;
        _context.callbackUser = callback;
        _context.userData = userData;
    }

    ~this()
    {
        if (_context !is null)
        {
            free(_context);
            _context = null;
        }
    }

    @disable this(this);

    /// Starts the thread. Threads are created suspended. This function can
    /// only be called once.
    void start()
    {
        version(Posix)
        {
            pthread_attr_t attr;

            int err = assumeNothrowNoGC(
                (pthread_attr_t* pattr)
                {
                    return pthread_attr_init(pattr);
                })(&attr);

            if (err != 0)
                assert(false);

            if(_stackSize != 0)
            {
                int err2 = assumeNothrowNoGC(
                    (pthread_attr_t* pattr, size_t stackSize)
                    {
                        return pthread_attr_setstacksize(pattr, stackSize);
                    })(&attr, _stackSize);
                if (err2 != 0)
                    assert(false);
            }

            int err3 = pthread_create(&_id, &attr, &posixThreadEntryPoint, _context);
            if (err3 != 0)
                assert(false);

            int err4 = assumeNothrowNoGC(
                (pthread_attr_t* pattr)
                {
                    return pthread_attr_destroy(pattr);
                })(&attr);
            if (err4 != 0)
                assert(false);
        }
        else version(Windows)
        {

            uint dummy;

            _id = cast(HANDLE) _beginthreadex(null,
                                              cast(uint)_stackSize,
                                              &windowsThreadEntryPoint,
                                              _context,
                                              CREATE_SUSPENDED,
                                              &dummy);
            if (cast(size_t)_id == 0)
                assert(false);
            if (ResumeThread(_id) == -1)
                assert(false);
        }
        else
            static assert(false);
    }

    /// Wait for that thread termination
    /// Again, this function can be called only once.
    /// This actually releases the thread resource.
    void join()
    {
        version(Posix)
        {
            void* returnValue;
            if (0 != pthread_join(_id, &returnValue))
                assert(false);
        }
        else version(Windows)
        {
            if(WaitForSingleObject(_id, INFINITE) != WAIT_OBJECT_0)
                assert(false);
            CloseHandle(_id);
        }
    }

    void* getThreadID()
    {
        version(Posix) return cast(void*)_id;
        else version(Windows) return cast(void*)_id;
        else assert(false);
    }

private:
    version(Posix)
    {
        pthread_t _id;
    }
    else version(Windows)
    {
        HANDLE _id;
    }
    else
        static assert(false);

    // Thread context given to OS thread creation function need to have a constant adress
    // since there are no guarantees the `Thread` struct will be at the same adress.
    static struct CreateContext
    {
    nothrow:
    @nogc:
        ThreadDelegate callback;
        ThreadDelegateUser callbackUser;
        void* userData;
        void call()
        {
            if (callback !is null)
                callback();
            else
                callbackUser(userData);
        }
    }
    CreateContext* _context;

    size_t _stackSize;
}

version(Posix)
{
    extern(C) void* posixThreadEntryPoint(void* threadContext) nothrow @nogc
    {
        Thread.CreateContext* context = cast(Thread.CreateContext*)(threadContext);
        context.call();
        return null;
    }
}

version(Windows)
{
    extern (Windows) uint windowsThreadEntryPoint(void* threadContext) nothrow @nogc
    {
        Thread.CreateContext* context = cast(Thread.CreateContext*)(threadContext);
        context.call();
        return 0;
    }
}

unittest
{
    int outerInt = 0;

    class A
    {
    nothrow @nogc:
        this()
        {
            t = makeThread(&f);
            t.start();
        }

        void join()
        {
            t.join();
        }

        void f()
        {
            outerInt = 1;
            innerInt = 2;

            // verify this
            assert(checkValue0 == 0x11223344);
            assert(checkValue1 == 0x55667788);
        }

        int checkValue0 = 0x11223344;
        int checkValue1 = 0x55667788;
        int innerInt = 0;
        Thread t;
    }

    auto a = new A;
    a.t.join();
    assert(a.innerInt == 2);
    a.destroy();
    assert(outerInt == 1);
}

/// Launch a function in a newly created thread, which is destroyed afterwards.
/// Return the thread so that you can call `.join()` on it.
Thread launchInAThread(ThreadDelegate dg, size_t stackSize = 0) nothrow @nogc
{
    Thread t = makeThread(dg, stackSize);
    t.start();
    return t;
}
