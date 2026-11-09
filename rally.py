"""Rally Dunas RN: deterministic, testable terminal racing simulator."""
from dataclasses import dataclass
import random


@dataclass
class Car:
    fuel: int = 100
    condition: int = 100
    distance: int = 0


def drive(car: Car, throttle: int, terrain: str, rng: random.Random) -> Car:
    if not 0 <= throttle <= 100:
        raise ValueError("Throttle must be between 0 and 100")
    if terrain not in {"sand", "road", "rocks"}:
        raise ValueError("Unknown terrain")
    resistance = {"sand": 3, "road": 1, "rocks": 4}[terrain]
    fuel_cost = max(1, throttle // 12 + resistance)
    if car.fuel < fuel_cost or car.condition <= 0:
        return car
    car.fuel -= fuel_cost
    car.distance += max(1, throttle // 10 - resistance + rng.randint(0, 2))
    car.condition = max(0, car.condition - (resistance if throttle > 70 else 0))
    return car


def main():
    car = Car()
    rng = random.Random()
    print("Rally Dunas RN — reach 100 km! Enter throttle 0-100, or q to quit.")
    while car.fuel and car.condition and car.distance < 100:
        raw = input("Throttle> ").strip()
        if raw.lower() == "q":
            break
        try:
            throttle = int(raw)
            terrain = rng.choice(["sand", "road", "rocks"])
            drive(car, throttle, terrain, rng)
            print(f"{terrain}: {car.distance} km | fuel {car.fuel} | car {car.condition}")
        except ValueError as exc:
            print(exc)
    print("Finish!" if car.distance >= 100 else "Race ended.")


if __name__ == "__main__":
    main()
