# Flywheel Inverted Pendulum

**Bachelor's thesis project - stabilization of an inverted pendulum through the electronic control of a flywheel.**

This repository contains the material for my bachelor's thesis project: an inverted pendulum stabilization system based on a controlled flywheel.

The idea is simple to state and annoying to make work: take a naturally unstable mechanical system, measure what it is doing, spin a flywheel with the right control logic, and use the reaction torque to push the pendulum back toward its unstable equilibrium point.

No magic. Just mechanics, electronics, control theory, motor actuation, sensors, and a generous amount of practical debugging.

The full thesis document is available here:

- [Thesis.pdf](./Thesis.pdf)

---

## Project overview

The project focuses on the stabilization of an inverted pendulum using an electronically controlled flywheel.

An inverted pendulum is unstable by nature: if left alone, it falls. The goal of the system is to detect the pendulum motion and control the flywheel so that the generated reaction torque helps bring the pendulum back toward the vertical position.

In practical terms, the project combines:

- mechanical system design;
- angular motion sensing;
- embedded control logic;
- electric motor actuation;
- flywheel dynamics;
- feedback control;
- experimental testing and tuning.

This is not a simulation-only project. The point was to build and study a physical system where theory meets hardware, tolerances, noise, wiring, friction and all the usual suspects.

---

## System concept

The system can be summarized as a closed-loop control problem.

```text
Pendulum motion
      |
      v
Angle / motion sensing
      |
      v
Embedded controller
      |
      v
Motor driver
      |
      v
Flywheel motor
      |
      v
Reaction torque on pendulum
      |
      v
Pendulum correction
```

The controller receives information about the pendulum state, computes the required actuation and drives the flywheel motor. The flywheel then produces a mechanical reaction on the pendulum body, creating the possibility of stabilization.

The interesting part is that the actuator is not pushing the pendulum directly. It acts through the angular momentum of a rotating mass. That makes the project more awkward, and therefore more educational.

---

## What the project demonstrates

This project is useful to show:

- fundamentals of control systems;
- embedded system development;
- sensor acquisition and signal interpretation;
- motor control and actuation;
- mechanical/electrical/software integration;
- experimental validation on a real physical setup;
- debugging of an unstable dynamic system;
- ability to move from mathematical model to working prototype.

For a portfolio, the relevant point is not that the system was a polished product. It was a complete academic engineering project: model, build, control, test, adjust, repeat.

---

## Technical focus

### Inverted pendulum dynamics

The core problem is the stabilization of an unstable equilibrium. The pendulum naturally moves away from the vertical position, so the system needs feedback control to react fast enough and in the correct direction.

### Flywheel-based actuation

Instead of using a direct linear actuator or a moving cart, the project uses a flywheel. By accelerating or decelerating the flywheel, the system generates a reaction torque that influences the pendulum body.

### Embedded control

The controller must acquire sensor data, estimate the current state of the system and command the motor actuation. Timing and response are important because the plant is unstable by design.

### Hardware/software interaction

The project requires the control logic to deal with a real physical implementation. That means non-ideal sensors, non-perfect mechanics, motor limits, electrical constraints and practical tuning.

---

## Repository content

The main reference document is:

```text
Thesis.pdf
```

It contains the complete thesis work and should be read as the primary technical explanation of the project.

The repository is published mainly as an academic and portfolio reference for the project, not as a plug-and-play software package.

---

## Project status

This is a historical bachelor's thesis project. It documents the design and development work carried out during my undergraduate studies in electronic engineering.

The project should be read as:

- an academic control-system project;
- a hands-on embedded/electromechanical prototype;
- a demonstration of applied electronics and control theory;
- an early but meaningful engineering project.

It should not be read as:

- a finished commercial product;
- a production-ready control platform;
- a generic reusable library.

---

## Why this project matters

The project is relevant because it sits at the intersection of several engineering areas:

```text
Control theory
      +
Embedded electronics
      +
Motor actuation
      +
Mechanical dynamics
      +
Real-world debugging
```

That combination is exactly why the project was valuable. A model can look clean on paper; a real pendulum usually has other opinions.

---

## Author

**Riccardo Medvescek**  
Bachelor's thesis project in electronic engineering, focused on the stabilization of an inverted pendulum through electronic control of a flywheel.
