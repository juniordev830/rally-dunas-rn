"""Deterministic prototype for steering and checkpoint rules, not a 3D engine."""
from dataclasses import dataclass
from math import cos, sin, radians, isfinite


def number(value, label):
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not isfinite(value):
        raise ValueError(f"{label} must be finite")
    return float(value)


@dataclass
class Vehicle:
    x: float = 0
    y: float = 0
    heading: float = 0
    speed: float = 0

    def drive(self, throttle: float, steering: float, dt: float):
        throttle, steering, dt = (number(throttle, "throttle"),
                                  number(steering, "steering"), number(dt, "dt"))
        if not -1 <= throttle <= 1 or not -1 <= steering <= 1 or not 0 < dt <= 0.1:
            raise ValueError("invalid control values")
        self.speed = max(-5, min(25, self.speed + throttle * 8 * dt))
        self.heading = (self.heading + steering * 90 * dt) % 360
        self.x += cos(radians(self.heading)) * self.speed * dt
        self.y += sin(radians(self.heading)) * self.speed * dt


class Rally:
    """Track checkpoints are numbered 0..N-1, in order."""

    def __init__(self, checkpoints: int = 3):
        if type(checkpoints) is not int or not 1 <= checkpoints <= 30:
            raise ValueError("checkpoints must be between 1 and 30")
        self.checkpoints = checkpoints
        self.reset()

    def reset(self):
        self.car = Vehicle()
        self.time = 0.0
        self.next_checkpoint = 0
        self.running = False
        self.paused = False
        self.finished = False

    def start(self):
        if self.running or self.finished:
            raise ValueError("race already started or finished")
        self.running = True

    def pause(self, value=True):
        if not isinstance(value, bool):
            raise ValueError("pause must be boolean")
        self.paused = value

    def tick(self, throttle, steering, dt):
        if not self.running or self.paused:
            return
        self.car.drive(throttle, steering, dt)
        self.time += dt

    def checkpoint(self, index):
        if not self.running or self.paused or index != self.next_checkpoint:
            raise ValueError("checkpoint out of order or race not running")
        self.next_checkpoint += 1

    def finish(self):
        if not self.running or self.paused or self.next_checkpoint != self.checkpoints:
            raise ValueError("complete all checkpoints before the finish")
        self.finished, self.running = True, False
        return round(self.time, 3)


if __name__ == "__main__":
    race = Rally(1)
    race.start()
    for _ in range(100):
        race.tick(0.5, 0.0, 0.02)
    race.checkpoint(0)
    print("Lap finished in", race.finish(), "seconds")
