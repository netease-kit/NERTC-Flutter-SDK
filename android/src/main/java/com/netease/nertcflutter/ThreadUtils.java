// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
package com.netease.nertcflutter;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.util.Log;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class ThreadUtils {
  private static final Object sLock = new Object();
  private static Handler sUiThreadHandler;

  /**
   *   获取UI线程到handler
   *
   * @return Handler UI线程Handler
   */
  public static Handler getUiThreadHandler() {
    synchronized (sLock) {
      if (sUiThreadHandler == null) {
        sUiThreadHandler = new Handler(Looper.getMainLooper());
      }
      return sUiThreadHandler;
    }
  }

  /**
   *   以同步方式在UI 线程上执行
   *
   * @param r Runnable
   */
  public static void runOnUiThreadBlocking(final Runnable r) {
    runOnThreadBlocking(getUiThreadHandler(), r);
  }

  /**
   *   以同步或者异步方式在UI线程上执行
   *
   * @param r Runnable
   */
  public static void runOnUiThread(Runnable r) {
    if (runningOnUiThread()) {
      r.run();
    } else {
      getUiThreadHandler().post(r);
    }
  }

  /**
   *   以异步方式在UI线程上，等待一段时间后执行
   *
   * @param r Runnable
   * @param delayMs 等待时间
   */
  public static void runOnUiThreadDelay(Runnable r, long delayMs) {
    getUiThreadHandler().postDelayed(r, delayMs);
  }

  /**
   *   以异步方式在UI线程上执行
   *
   * @param c 待执行的任务
   */
  public static <T> T runOnUiThreadBlocking(Callable<T> c) {
    return runOnThreadBlocking(getUiThreadHandler(), c);
  }

  private static boolean runningOnUiThread() {
    return getUiThreadHandler().getLooper() == Looper.myLooper();
  }

  /**
   *   获取线程信息
   *
   * @return String 线程信息
   */
  public static String getThreadInfo() {
    return "@[name="
        + Thread.currentThread().getName()
        + ", id="
        + Thread.currentThread().getId()
        + "]";
  }

  /**   检查当前线程是否是UI线程，debug用 */
  public static void checkIsOnUiThread() {
    if (Thread.currentThread() != Looper.getMainLooper().getThread()) {
      //            throw new IllegalStateException("Not on ui thread!");
      //FIXME:下个版本打开
      Log.e("ThreadUtils", "Not on ui thread!");
    }
  }

  interface BlockingOperation {
    void run() throws InterruptedException;
  }

  private static void executeUninterruptibly(BlockingOperation operation) {
    boolean wasInterrupted = false;
    while (true) {
      try {
        operation.run();
        break;
      } catch (InterruptedException e) {
        wasInterrupted = true;
      }
    }
    if (wasInterrupted) {
      Thread.currentThread().interrupt();
    }
  }

  /**
   *   在一段时间内，以非打断的方式等待指定线程执行完
   *
   * @param thread 指定的执行线程
   * @param timeoutMs 等待的时间
   * @return boolean 指定的线程是否死亡
   */
  public static boolean joinUninterruptibly(final Thread thread, long timeoutMs) {
    final long startTimeMs = SystemClock.elapsedRealtime();
    long timeRemainingMs = timeoutMs;
    boolean wasInterrupted = false;
    while (timeRemainingMs > 0) {
      try {
        thread.join(timeRemainingMs);
        break;
      } catch (InterruptedException e) {
        wasInterrupted = true;
        final long elapsedTimeMs = SystemClock.elapsedRealtime() - startTimeMs;
        timeRemainingMs = timeoutMs - elapsedTimeMs;
      }
    }

    if (wasInterrupted) {
      Thread.currentThread().interrupt();
    }
    return !thread.isAlive();
  }

  /**
   *   以非打断的方式等待指定线程执行完
   *
   * @param thread 指定的执行线程
   */
  public static void joinUninterruptibly(final Thread thread) {
    executeUninterruptibly(thread::join);
  }

  /**
   *   以非打断的方式等待指定线程执行
   *
   * @param object 指定的执行任务
   */
  public static void waitUninterruptibly(final Object object) {
    executeUninterruptibly(object::wait);
  }

  /**
   *   以非打断的方式等待指定线程执行， 直到CountDownLatch为0
   *
   * @param latch CountDownLatch 等待count直至0
   */
  public static void awaitUninterruptibly(final CountDownLatch latch) {
    executeUninterruptibly(latch::await);
  }

  /**
   *   在指定的时间内，以非打断的方式等待指定线程执行， 直到CountDownLatch为0
   *
   * @param barrier CountDownLatch 等待count直至0
   * @param timeoutMs 等待时间
   */
  public static boolean awaitUninterruptibly(CountDownLatch barrier, long timeoutMs) {
    final long startTimeMs = SystemClock.elapsedRealtime();
    long timeRemainingMs = timeoutMs;
    boolean wasInterrupted = false;
    boolean result = false;
    do {
      try {
        result = barrier.await(timeRemainingMs, TimeUnit.MILLISECONDS);
        break;
      } catch (InterruptedException e) {
        wasInterrupted = true;
        final long elapsedTimeMs = SystemClock.elapsedRealtime() - startTimeMs;
        timeRemainingMs = timeoutMs - elapsedTimeMs;
      }
    } while (timeRemainingMs > 0);
    if (wasInterrupted) {
      Thread.currentThread().interrupt();
    }
    return result;
  }

  /**
   *  以异步方式执行，不执行完，不返回
   *
   * @param handler 线程handler
   * @param callable 执行的任务
   */
  public static <V> V runOnThreadBlocking(final Handler handler, final Callable<V> callable) {
    if (handler.getLooper().getThread() == Thread.currentThread()) {
      try {
        return callable.call();
      } catch (Exception e) {
        throw new RuntimeException(e);
      }
    }
    class CaughtException {
      Exception e;
    }
    class Result {
      public V value;
    }
    final Result result = new Result();
    final CaughtException caughtException = new CaughtException();
    final CountDownLatch barrier = new CountDownLatch(1);
    handler.post(
        () -> {
          try {
            result.value = callable.call();
          } catch (Exception e) {
            caughtException.e = e;
          }
          barrier.countDown();
        });
    awaitUninterruptibly(barrier);
    if (caughtException.e != null) {
      final RuntimeException runtimeException = new RuntimeException(caughtException.e);
      runtimeException.setStackTrace(
          concatStackTraces(caughtException.e.getStackTrace(), runtimeException.getStackTrace()));
      throw runtimeException;
    }
    return result.value;
  }

  /**
   *  以异步方式执行，不执行完，不返回
   *
   * @param handler 线程handler
   * @param runner 执行的任务
   */
  public static void runOnThreadBlocking(final Handler handler, final Runnable runner) {
    runOnThreadBlocking(
        handler,
        (Callable<Void>)
            () -> {
              runner.run();
              return null;
            });
  }

  /**
   *  以异步或者同步的方式执行
   *
   * @param handler 线程handler
   * @param runner 执行的任务
   */
  public static void runOnThread(Handler handler, final Runnable runner) {
    if (handler.getLooper().getThread() == Thread.currentThread()) {
      try {
        runner.run();
      } catch (Exception e) {
        throw new RuntimeException(e);
      }
    } else {
      handler.post(runner);
    }
  }

  /**
   *  以异步或者同步的方式，等待一段时间执行
   *
   * @param handler 线程handler
   * @param runner 执行的任务
   * @param delayMills 等待的时间
   */
  public static void runOnThreadDelay(Handler handler, Runnable runner, long delayMills) {
    if (delayMills <= 0) {
      runOnThread(handler, runner);
    } else {
      handler.postDelayed(runner, delayMills);
    }
  }

  /**
   *  以异步或者同步的方式，等待一段时间执行，token变化的情况
   *
   * @param handler 线程handler
   * @param runner 执行的任务
   * @param delayMills 等待的时间
   * @param token 通信令牌
   */
  public static void runOnThreadDelayWithToken(
      Handler handler, Runnable runner, long delayMills, Object token) {
    if (delayMills <= 0) {
      runOnThread(handler, runner);
    } else {
      // 按照token移除上一次
      handler.removeCallbacksAndMessages(token);
      // post新的
      Message message = Message.obtain(handler, runner);
      message.obj = token;
      handler.sendMessageDelayed(message, delayMills);
    }
  }

  /**
   *  线程的消息队列中，移除runnable
   *
   * @param handler 线程handler
   * @param runner 执行的任务
   */
  public static void removeRunnableOnThread(Handler handler, Runnable runner) {
    handler.removeCallbacks(runner);
  }

  /**
   *  线程的消息队列中，移除带token的runnable
   *
   * @param handler 线程handler
   * @param token 执行的任务
   */
  public static void removeRunnableOnThreadWithToken(Handler handler, Object token) {
    handler.removeCallbacksAndMessages(token);
  }

  private static StackTraceElement[] concatStackTraces(
      StackTraceElement[] inner, StackTraceElement[] outer) {
    final StackTraceElement[] combined = new StackTraceElement[inner.length + outer.length];
    System.arraycopy(inner, 0, combined, 0, inner.length);
    System.arraycopy(outer, 0, combined, inner.length, outer.length);
    return combined;
  }
}
