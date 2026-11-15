import unittest
from math import isnan
from core import Rally, Vehicle


class RallyTests(unittest.TestCase):
    def test_checkpoint_order_and_finish(self):
        game = Rally(2)
        game.start()
        game.tick(1, 0, 0.05)
        with self.assertRaises(ValueError):
            game.checkpoint(1)
        with self.assertRaises(ValueError):
            game.finish()
        game.checkpoint(0)
        game.checkpoint(1)
        self.assertEqual(game.finish(), 0.05)
        self.assertTrue(game.finished)

    def test_pause_and_reset(self):
        game = Rally(1)
        game.start()
        game.pause()
        game.tick(1, 0, .05)
        self.assertEqual(game.time, 0)
        game.pause(False)
        game.tick(1, 0, .05)
        self.assertGreater(game.car.speed, 0)
        game.reset()
        self.assertEqual(game.time, 0)
        self.assertEqual(game.car, Vehicle())

    def test_vehicle_is_deterministic(self):
        a, b = Vehicle(), Vehicle()
        for _ in range(20):
            a.drive(.8, .25, .05)
            b.drive(.8, .25, .05)
        self.assertEqual(a, b)

    def test_invalid_controls(self):
        car = Vehicle()
        for x, y, dt in [(2,0,.05),(0,-2,.05),(0,0,1),(float("nan"),0,.05)]:
            with self.assertRaises(ValueError):
                car.drive(x, y, dt)
        self.assertEqual(car, Vehicle())


if __name__ == "__main__":
    unittest.main()
