---
title: "Learn ROS2 and Gazebo"
date: 2026-02-04
tags: [ROS2, Gazebo]
draft: true
---



## Mastering the Future of Robotics: A Guide to ROS 2 and Gazebo

Welcome to the cutting edge of robotics development! If you're looking to build everything from autonomous vacuum cleaners to industrial arms, you’ve come to the right place. Today, we’re diving into the two most essential tools in a roboticist's toolkit: **ROS 2 (Robot Operating System)** and **Gazebo**.

Whether you're an experienced Python developer or a newcomer to the field, this duo provides the framework and the playground you need to turn code into physical motion.

---

## 🤖 What is ROS 2?

Contrary to its name, ROS 2 isn't a traditional operating system like Windows or Linux. Instead, it’s a powerful set of **software libraries and tools** designed to help you build robot applications. It handles the "plumbing" of a robot—letting different parts (like sensors and motors) talk to each other seamlessly.

### Key Core Concepts:

* **Nodes**: The smallest unit of execution. Think of a node as a single "app" on your robot (e.g., one node for the camera, one for the wheels).


* **Topics**: A way for nodes to exchange data. One node "publishes" a message, and another "subscribes" to it.


* **Services**: Used for quick "request-response" interactions, like asking a robot to calculate a path.


* **Actions**: Best for long-running tasks, like "drive to the kitchen," where you need constant feedback on progress.



---

## 🌍 What is Gazebo?

If ROS 2 is the "brain," **Gazebo** is the "world." It is a high-fidelity 3D robotics simulator that allows you to test your robot in a virtual environment before risking expensive hardware in the real world.

### Why use Gazebo?

* **Physics Engine**: It accurately simulates gravity, friction, and collision.


* **Sensor Simulation**: You can add virtual LIDARs, cameras, and IMUs to your robot.


* **Fuel Cloud**: A massive library of ready-to-use 3D models (like buildings, robots, and furniture) that you can drag and drop into your simulation.



---

## ⚙️ Setting Up Your Environment

Getting started depends on your operating system. For the most stable experience, **Ubuntu Linux** is highly recommended.

### 1. Install ROS 2

As of early 2026, the current development distribution is **Rolling Ridley**. However, for long-term projects, you might choose:

* **Kilted Kaiju**: Released in May 2025.


* **Jazzy Jalisco**: A popular stable release.



**Quick Start (Ubuntu):**
You can install ROS 2 using standard Debian packages (`.deb`). Once installed, you'll use tools like `colcon` to build your code and `ros2doctor` to check for issues.

### 2. Install Gazebo

Gazebo releases are often paired with ROS 2 versions.

* **Gazebo Jetty (LTS)**: Supported until 2030, this is the current recommended version for Ubuntu 24.04.


* **Gazebo Harmonic**: The recommended choice if you are using ROS 2 Jazzy.



**Launching Gazebo:**
Simply run the following command in your terminal to see a default world with basic shapes:

```bash
gz sim -v 4

```

> 
> **Pro Tip:** Use the `-s` flag to run Gazebo "headless" (without the 3D window) to save CPU power during heavy computations.
> 
> 

---

## 🛠️ The Power of Integration

The real magic happens when you connect ROS 2 to Gazebo. This allows your ROS 2 nodes to control the virtual robot in Gazebo as if it were real.

1. **URDF Models**: You define your robot's appearance and physical properties using a **Unified Robot Description Format (URDF)** file.


2. **Simulation Interfaces**: Use ROS 2 "Bridge" packages to send velocity commands from your ROS code into the Gazebo physics engine.


3. **Visualization**: Use **RViz** alongside Gazebo to see what your robot "sees" (like sensor data overlays).



