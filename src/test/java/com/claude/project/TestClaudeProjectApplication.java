package com.claude.project;

import org.springframework.boot.SpringApplication;

public class TestClaudeProjectApplication {

	public static void main(String[] args) {
		SpringApplication.from(ClaudeProjectApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
