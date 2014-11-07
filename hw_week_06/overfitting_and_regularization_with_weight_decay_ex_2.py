import numpy;

def loadData(filename):
    data = numpy.loadtxt(filename);
    return data[:,0:2], data[:,2]

def transform(X):
    
    return X;

X,y = loadData("in.dta");


print(X);
print(y);

Xtst,ytst = loadData("out.dta")
