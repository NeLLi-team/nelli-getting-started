import pandas as pd
import polars as pl
from sklearn.ensemble import RandomForestClassifier

# toy: build fake features from clusters.tsv (MMseqs2)
TSV = "clusters.tsv"
df = pd.read_csv(TSV, sep="\t", header=None, names=["q", "t", "clu"])

# dummy labels by cluster parity
df["y"] = (df["clu"].astype(str).str[-1].astype(int) % 2).astype(int)
X = pd.get_dummies(df["clu"])
clf = RandomForestClassifier(n_estimators=50, random_state=0).fit(X, df["y"])
print("Model trained; classes:", clf.classes_)

