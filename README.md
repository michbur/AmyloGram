[![published in: Scientific Reports](https://img.shields.io/badge/published%20in-Scientific%20Reports-green.svg)](https://doi.org/10.1038/s41598-017-13210-9)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/AmyloGram)](https://cran.r-project.org/package=AmyloGram)
[![Downloads](http://cranlogs.r-pkg.org/badges/AmyloGram)](https://cran.r-project.org/package=AmyloGram)
[![Build Status](https://api.travis-ci.org/michbur/AmyloGram.png)](https://travis-ci.org/michbur/AmyloGram)

<img src="https://github.com/michbur/AmyloGram/blob/master/inst/AmyloGram/AmyloGram_logo.png" alt="AmyloGram" style="height: 200px;"/>

Predict amyloid proteins
-------------------------

AmyloGram predicts amyloid proteins using n-gram encoding and random forests. It can be also accessed as a web-based service http://www.smorfland.uni.wroc.pl/shiny/AmyloGram/. 

Local instance of AmyloGram
------------------------
AmyloGram can be used installed from CRAN as the R package:

```R
install.packages("AmyloGram")
```

You can install the latest development version of the package:

```R
source("https://raw.githubusercontent.com/r-lib/remotes/master/install-github.R")$value("michbur/AmyloGram")
```

After installation GUI can be accessed locally:

```R
library(AmyloGram)
AmyloGram_gui()
```

Predictions might be also made in the batch mode:

```R
data(AmyloGram_model)
data(pep424)
predict(AmyloGram_model, pep424[1L:20])
```
