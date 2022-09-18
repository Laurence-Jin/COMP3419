Completed Requirements: #all

In global, I set array list ball to store class Ball which contains the info about ball created through clicking. And there are severals number like horizontal energy lost(HORIENELOST) restricted the scale.

Ball is a class stored its info like speed, coordinate and so on. Then it loads the texture of ball through globe and img, as each time call the Ball class, it will go through random no of texture, then each time click will generate various texture.

Then, run() is refer to call all the process of working, I set boolean Ymove, XZmove to identify whether ball should move in typical case like touch the wall.

Collide() is refer to the collision only between 'ball', it is determined through their diameter and their distance between another.

display() is to show the ball in typical location through clicking using pushMatrix and pop to split each translate().

gravity_y() is not only work as its name, but also change the speed in collision to wall, there is accelerate speed due to gravity in Ymove, if y is out of bound with if will be the no of width and do the anti-direction by minus speed. Vertical energy lost(VERTENLOST) set the speed lost because of collision. If ball in a low speed and location in y-axis, it will stop moving as boolean Ymove.

gravity_xz() is similar with y.

mousePress used to add the current click location to Ball class and then the code call the run() to activate the work of ball.



