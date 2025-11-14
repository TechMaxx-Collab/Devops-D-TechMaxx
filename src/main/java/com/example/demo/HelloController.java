package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {
        // Yeh 'v1' hum baad mein change karenge
        return "Hello from GitOps App - v1! 🚀"; 
    }
}