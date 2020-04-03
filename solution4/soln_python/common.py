import numpy as np

K                  = np.loadtxt('../data/cameraK.txt')
p_model            = np.loadtxt('../data/model.txt')
platform_to_camera = np.loadtxt('../data/pose.txt')

def residuals(uv, weights, yaw, pitch, roll):
    base_to_platform = translate(0.1145/2, 0.1145/2, 0.0)@rotate_z(yaw)
    hinge_to_base    = translate(0, 0, 0.325)@rotate_y(pitch)
    arm_to_hinge     = translate(0, 0, -0.0552)
    rotors_to_arm    = translate(0.653, 0, -0.0312)@rotate_x(roll)
    base_to_camera   = platform_to_camera@base_to_platform
    hinge_to_camera  = base_to_camera@hinge_to_base
    arm_to_camera    = hinge_to_camera@arm_to_hinge
    rotors_to_camera = arm_to_camera@rotors_to_arm

    m = p_model.shape[0]
    p_camera = np.empty([4, m])
    p_camera[:,:3] = arm_to_camera @ p_model[:3,:].T # First three points
    p_camera[:,3:] = rotors_to_camera @ p_model[3:,:].T # Last four points

    uv_hat = K @ p_camera[:3,:]
    uv_hat /= uv_hat[2,:]
    uv_hat = uv_hat[:2,:].T

    return weights*np.linalg.norm(uv - uv_hat, axis=1)

def normal_equations(uv, weights, yaw, pitch, roll):
    eps=0.00001 # Finite-difference epsilon
    r = residuals(uv, weights, yaw, pitch, roll)
    J = np.array([
        (residuals(uv, weights, yaw+eps, pitch, roll) - r)/eps,
        (residuals(uv, weights, yaw, pitch+eps, roll) - r)/eps,
        (residuals(uv, weights, yaw, pitch, roll+eps) - r)/eps
    ]).T
    return J.T@J, J.T@r

def gauss_newton(uv, weights, yaw, pitch, roll):
    max_iter = 100
    step_size = 0.25
    for iter in range(max_iter):
        JTJ, JTr = normal_equations(uv, weights, yaw, pitch, roll)
        step = np.linalg.solve(JTJ, -JTr)
        yaw += step_size*step[0]
        pitch += step_size*step[1]
        roll += step_size*step[2]
    return yaw, pitch, roll

def levenberg_marquardt(uv, weights, yaw, pitch, roll):
    JTJ, JTr = normal_equations(uv, weights, yaw, pitch, roll)
    r = residuals(uv, weights, yaw, pitch, roll)
    prev_error = r.T@r
    max_iter = 10
    xtol = 0.001
    Lambda = 0.001*np.average([JTJ[0,0], JTJ[1,1], JTJ[2,2]])
    for iter in range(max_iter):
        JTJ, JTr = normal_equations(uv, weights, yaw, pitch, roll)
        step = np.linalg.solve(JTJ + Lambda*np.eye(3), -JTr)
        next_yaw = yaw + step[0]
        next_pitch = pitch + step[1]
        next_roll = roll + step[2]
        r = residuals(uv, weights, next_yaw, next_pitch, next_roll)
        error = r.T@r
        if error < prev_error:
            prev_error = error
            yaw = next_yaw
            pitch = next_pitch
            roll = next_roll
            Lambda *= 0.1
            if np.linalg.norm(step) < xtol:
                break
        else:
            Lambda *= 10.0
    return yaw, pitch, roll

def rotate_x(radians):
    c = np.cos(radians)
    s = np.sin(radians)
    return np.array([[1, 0, 0, 0],
                     [0, c,-s, 0],
                     [0, s, c, 0],
                     [0, 0, 0, 1]])

def rotate_y(radians):
    c = np.cos(radians)
    s = np.sin(radians)
    return np.array([[ c, 0, s, 0],
                     [ 0, 1, 0, 0],
                     [-s, 0, c, 0],
                     [ 0, 0, 0, 1]])

def rotate_z(radians):
    c = np.cos(radians)
    s = np.sin(radians)
    return np.array([[c,-s, 0, 0],
                     [s, c, 0, 0],
                     [0, 0, 1, 0],
                     [0, 0, 0, 1]])

def translate(x, y, z):
    return np.array([[1, 0, 0, x],
                     [0, 1, 0, y],
                     [0, 0, 1, z],
                     [0, 0, 0, 1]])
