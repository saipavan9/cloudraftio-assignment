for i in $(seq 1 10); do
  {
    echo "Request #$i"
    curl -w " Status: %{http_code} | Time: %{time_total}s\n" http://local.metrics-app.io/counter || echo "Request failed"
    echo "--------"
  } >> response.txt
  sleep 1
done
