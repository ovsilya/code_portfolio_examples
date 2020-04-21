import pandas as pd
from scipy.stats import mode

import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm
from sklearn.neighbors import KernelDensity
import seaborn as sns

# -------------------------- DataFrame --------------------------------


data = pd.read_csv("teachers_limited_to_15k.csv")
# print(data.head(3))
print(data.columns)

data_filered = data.loc[(data["language"] == "ca") & (data["country"] == "US"),
                                                        ["language", "country"]]

row_by_index = data_filered.iloc[1]

data["teacher_first_name"].apply(lambda x: "AAAAAAAAAAA")
axis = 1  # if we need to apply for each row, by default - columns
print(data.head(3))

modes = mode(data["country"]).mode[0]
data['country'].fillna(modes, inplace=True)
print(data['country'])

# The mode is the statistical term that refers to the most frequently occurring number found in a set of numbers.

data = data["country"].dropna()

# for a specific column

data.apply(np.isnull(), axis=0)
data['Gender'].fillna(mode(data['Gender']).mode[0], inplace=True)


# -------------------------- Numpy Array --------------------------------

numpy_array = data.to_numpy()
print(numpy_array[1, :])  # numpy_array = [row, column]
X = data['engagement_index'].to_numpy()[:, np.newaxis]

