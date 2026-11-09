import random
import unittest
from rally import Car, drive


class RallyTests(unittest.TestCase):
    def test_invalid_throttle(self):
        with self.assertRaises(ValueError):
            drive(Car(), 101, "sand", random.Random(1))

    def test_drive_uses_fuel(self):
        car = drive(Car(), 60, "road", random.Random(1))
        self.assertLess(car.fuel, 100)
        self.assertGreater(car.distance, 0)

    def test_no_fuel_stops_car(self):
        car = Car(fuel=0)
        drive(car, 80, "sand", random.Random(1))
        self.assertEqual(car.distance, 0)


if __name__ == "__main__":
    unittest.main()
