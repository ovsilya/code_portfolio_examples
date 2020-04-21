import seaborn as sns
from sys import platform as sys_pf
if sys_pf == 'darwin':
    import matplotlib
    matplotlib.use("TkAgg")

from matplotlib import pyplot as plt
import pandas as pd
import scipy.stats as stats
import numpy as np
data = pd.read_csv("activity_data.csv")

engagement_index = data['engagement_index'].to_numpy()

# sns.distplot(engagement_index, bins=150, kde=False, rug=False)
# plt.savefig('foo.png')

fit_alpha, fit_loc, fit_beta = stats.gamma.fit(engagement_index)
print(fit_alpha, fit_loc, fit_beta)

x = np.linspace(0, 1, 30)

y1 = stats.gamma.pdf(x, a=fit_alpha, scale=1/fit_beta, loc=fit_loc)
plt.plot(y1)
plt.savefig('gamma.png')

################################################################################
