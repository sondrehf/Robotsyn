from scipy.io import loadmat
import matplotlib.pyplot as plt
import numpy as np

from PIL import Image
from io import BytesIO
#import webcolors

# data analysis
import math
import numpy as np
#import pandas as pd

# visualization
import matplotlib.pyplot as plt
from importlib import reload
from mpl_toolkits import mplot3d
#import seaborn as sns

# modeling
#from sklearn.cluster import KMeans
#from sklearn.decomposition import PCA
#from sklearn.preprocessing import MinMaxScaler

def show_image(X):
    plt.imshow(np.reshape(X.T, [H,W,L]))

def error(X, X_ref):
    return np.mean(np.linalg.norm(X - X_ref, axis=0)) / \
        np.mean(np.linalg.norm(X_ref, axis=0))


def main(): 
    data = loadmat('data/task_3_case_1.mat') # Case 1
    # data = loadmat('data/task_3_case_2.mat') # Case 2
    I_noisy    = data['I_noisy']
    ori_img = data['I_original']
    orig_image = Image.open(data['I_original'])


    X = np.array(ori_img.getdata())
    ori_pixels = X.reshape(*ori_img.size, -1)
    ori_pixels.shape

main()




I_noisy    = data['I_noisy']
I_original = data['I_original']
sigma_n    = data['Sigma_n']

H,W,L      = I_original.shape
X          = np.reshape(I_noisy, [H*W,L]).T
X_original = np.reshape(I_original, [H*W,L]).T
sigma      = np.cov(X)

# Todo: Compute the MNF reconstruction of X
X_hat_mnf = np.zeros(X.shape)

# Todo: Compute the PCA reconstruction of X
X_hat_pca = np.zeros(X.shape)

# Compute relative error (error), between 0 and 1
error_mnf = error(X_hat_mnf, X_original)
error_pca = error(X_hat_pca, X_original)

plt.subplot(221)
show_image(X_original)
plt.title('Original')
plt.subplot(222)
show_image(X)
plt.title('Noisy')
plt.subplot(223)
show_image(X_hat_mnf)
plt.title('MNF, error = %.1f%%' % (100*error_mnf))
plt.subplot(224)
show_image(X_hat_pca)
plt.title('PCA, error = %.1f%%' % (100*error_pca))
plt.tight_layout()
plt.show()
