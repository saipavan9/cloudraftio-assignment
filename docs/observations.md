Application Behavior & Observations
======================================

Expected Behavior
-------------------

The app should return an incrementing counter value on each hit to `/counter`, for example:

```
curl http://local.metrics-app.io/counter
Counter value: 1
Counter value: 2
Counter value: 3
...

```

Actual Observed Behavior
---------------------------
Running the following test script `timing.sh`:

```
for i in $(seq 1 10); do
  curl -w " Status: %{http_code} | Time: %{time_total}s\n" -o - -s http://local.metrics-app.io/counter
done

```

### Results:

```
Request #1
Counter value: 1 Status: 200 | Time: 0.021798s
--------
Request #2
Counter value: 2 Status: 200 | Time: 31.022791s
--------
Request #3
Counter value: 3 Status: 200 | Time: 0.004977s
--------
Request #4
Counter value: 4 Status: 200 | Time: 22.010781s
--------
Request #5
Counter value: 5 Status: 200 | Time: 0.004645s
--------
Request #6
Counter value: 6 Status: 200 | Time: 28.018667s
--------
Request #7
Counter value: 7 Status: 200 | Time: 0.012440s
--------
Request #8
Counter value: 8 Status: 200 | Time: 35.009772s
--------
Request #9
Counter value: 9 Status: 200 | Time: 0.005643s
--------
Request #10
Counter value: 10 Status: 200 | Time: 41.012835s
--------
```

Resource Analysis
--------------------

-   **CPU usage:** Jumped from ~1m to over 1600m during long response requests

-   **Memory usage:** Stayed relatively constant (~27Mi)

-   **Pod restarts:** None

-   **Logs:** No visible errors or stack traces in pod logs

Root Cause Analysis
----------------------

The application triggers background collection on **every even-numbered request**. From the app source code:

```
if counter % 2 == 0:
    metrics.trigger_background_collection()

```

This function likely launches an **expensive or blocking operation**, not truly asynchronous. That leads to:

-   Very high latency for even-numbered requests
-   Unresponsive behavior despite normal pod health

Suggested Fix
-----------------
-   Refactor `metrics.trigger_background_collection()` to run asynchronously (e.g., via `threading`, `concurrent.futures`, or `celery`)
-   Run Background Collection Asynchronously
-   Set a timeout or throttle the metric collection
-   Add logging to monitor internal delays