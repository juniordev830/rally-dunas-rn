"""Deterministic, dependency-free rally vehicle physics prototype."""
from dataclasses import dataclass
from math import cos, sin, radians

SURFACE_GRIP = {"asphalt": 1.0, "sand": 0.65, "wet_sand": 0.45}

@dataclass
class Car:
    x: float = 0.0
    y: float = 0.0
    heading_deg: float = 0.0
    speed_mps: float = 0.0

    def step(self, throttle: float, steering: float, dt: float, surface: str = "sand") -> None:
        """Advance one simulation tick; controls range from -1 to 1."""
        if surface not in SURFACE_GRIP:
            raise ValueError(f"Unknown surface: {surface}")
        if not 0 < dt <= 0.1:
            raise ValueError("dt must be in (0, 0.1]")
        if not -1 <= throttle <= 1 or not -1 <= steering <= 1:
            raise ValueError("Controls must be between -1 and 1")
        grip = SURFACE_GRIP[surface]
        acceleration = (6.0 * throttle * grip) - (0.16 * self.speed_mps)
        self.speed_mps = max(-8.0, min(38.0, self.speed_mps + acceleration * dt))
        turn_rate = 70.0 * steering * grip * min(abs(self.speed_mps) / 8.0, 1.0)
        self.heading_deg = (self.heading_deg + turn_rate * dt) % 360
        self.x += cos(radians(self.heading_deg)) * self.speed_mps * dt
        self.y += sin(radians(self.heading_deg)) * self.speed_mps * dt

def run_demo() -> Car:
    car = Car()
    for _ in range(100):
        car.step(throttle=1, steering=0.2, dt=0.05)
    return car

if __name__ == "__main__":
    print(run_demo())
