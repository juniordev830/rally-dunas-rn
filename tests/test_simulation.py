import unittest
from simulation import Car, run_demo

class TestCar(unittest.TestCase):
    def test_accelerates(self):
        car = Car()
        car.step(1, 0, 0.1)
        self.assertGreater(car.speed_mps, 0)

    def test_sand_has_less_grip_than_asphalt(self):
        sand, asphalt = Car(), Car()
        sand.step(1, 0, 0.1, "sand")
        asphalt.step(1, 0, 0.1, "asphalt")
        self.assertLess(sand.speed_mps, asphalt.speed_mps)

    def test_invalid_inputs(self):
        for kwargs in ({"dt": 0}, {"throttle": 2}, {"surface": "lava"}):
            with self.subTest(kwargs=kwargs):
                with self.assertRaises(ValueError):
                    Car().step(throttle=kwargs.get("throttle", 1),
                               steering=0, dt=kwargs.get("dt", 0.1),
                               surface=kwargs.get("surface", "sand"))

    def test_demo_moves(self):
        self.assertGreater(run_demo().x, 0)

if __name__ == "__main__":
    unittest.main()
