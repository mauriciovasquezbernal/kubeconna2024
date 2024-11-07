package main

import (
	"fmt"
	"os"
)

func main() {
	// Attempt to open a file that doesn't exist without error checking
	file, _ := os.Open("nonexistent_file.txt") // ignoring the error here

	// Attempt to use the file, which will cause a runtime panic if it's nil
	fmt.Println("File opened successfully:", file.Name())

	// Ensure the file is closed if it was actually opened
	defer file.Close()
}
