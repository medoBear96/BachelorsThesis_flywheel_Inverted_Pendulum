# Flywheel Inverted Pendulum

**Bachelor's thesis project - stabilization of an inverted pendulum through the electronic control of a flywheel.**

This repository contains most of the material of my bachelor's thesis project. This study was followed by the prof. S.Marsi of Università degli Studi di Trieste.

Thegoal is to take a naturally unstable mechanical system, create a mathematical model, add a flywheel with the right control logic, and use the reaction torque to push the pendulum back toward its unstable equilibrium point.

The full thesis document is available here:

- [Thesis.pdf](./Thesis.pdf)

---

## Project overview

The project combines:

- mechanical system design;
- angular motion sensing;
- embedded control logic;
- electric motor actuation;
- flywheel dynamics;
- feedback control;
- hardware selection;
- structure design
- experimental testing and tuning.

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

---


