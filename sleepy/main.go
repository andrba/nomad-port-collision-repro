package main

import (
	"context"
	"flag"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	port := flag.Int("port", 3002, "port to listen on")
	shutdownDelay := flag.Int("shutdown-delay", 0, "time to sleep before shutting down")
	flag.Parse()

	stopSignal := make(chan os.Signal, 1)
	signal.Notify(stopSignal, syscall.SIGINT, syscall.SIGTERM)

	server := &http.Server{Addr: fmt.Sprintf(":%d", *port)}

	go func() {
		fmt.Printf("Listening on port %d\n", *port)
		server.ListenAndServe()
	}()

	s := <-stopSignal

	fmt.Printf("received %s, going down in %d seconds\n", s, *shutdownDelay)
	time.Sleep(time.Duration(*shutdownDelay) * time.Second)
	server.Shutdown(context.TODO())
}
