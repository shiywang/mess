package main

import "fmt"

const stduentNum = 30

type HomeWork struct {
}

func student(hwChain chan HomeWork) {
    hwChain <- HomeWork{}
}

func teacher(hwChain chan HomeWork) {
    for i := 0; i < stduentNum; i++ {
        hw := <- hwChain
    }
}

func main() {

}


