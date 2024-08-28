package com.myorg;

import software.amazon.awscdk.App;
import software.amazon.awscdk.StackProps;

public class HelloCdkApp {
    public static void main(final String[] args) {
        App app = new App();
        new HelloCdkStack(app, "HelloCdkStack", StackProps.builder()
                .build());
        app.synth();
    }
}