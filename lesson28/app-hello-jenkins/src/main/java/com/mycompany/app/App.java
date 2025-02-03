package com.mycompany.app;

/**
 * Hello Jenkins!
 */
public class App {

    private static final String MESSAGE = "Hello Jenkins! Fail app!";

    public App() {}

    public static void main(String[] args) {
        System.out.println(MESSAGE);
    }

    public String getMessage() {
        return MESSAGE;
    }
}
