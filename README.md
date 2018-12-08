# IRESfinder

IRESfinder is a python package for the identification of RNA internal ribosome entry site in eukaryotic cell, and it can be further used to search for the core IRES region.

# Installation

The following software should be installed in your cluster or computer before running the lncScore.py.

*         Perl (>=5.10.1), https://www.perl.org/get.html.
*         Python (>= 2.7), https://www.python.org/downloads/.
*         The scikit-learn module, http://scikit-learn.org/stable/install.html.

In most use cases the best way to install Python and scikit-learn package on your system is by using Anaconda(https://www.continuum.io), which is an easy-to-install free Python distirbution and includes more than 400 of the most popular Python packages. Anaconda includes installers(https://www.continuum.io/downloads) for Windows, OS X, and Linux.

# Examples

Examples are provided in the 'examples' folder.
Examples:

     Using IRESfinder with mode 0 (default), user can get a IRES score (probablity) for each sequence in .fa file,
     Command: python IRESfinder.py -f examples/example_mode_0.fa -o example_mode_0.result

     Using IRESfinder with mode 1, user can specific the region to be identified in the '>xx" line of the .fa file,
     Command: python IRESfinder.py -f examples/example_mode_1.fa -o example_mode_1.result -m 1

     Using IRESfinder with mode 2, user can search for the core IRES region by a sliding window (w: window size; s: step size),
     Command: python IRESfinder.py -f examples/example_mode_2.fa -o example_mode_2.result -m 2 -w 174 -s 50

# Datasets

The IRES and non-IRES sequences in the training and testing datasets are provided in the 'dataset' folder.

# Author

IRESfinder is developed by Jian Zhao (zhao_doctor@hotmail.com). For questions and comments, please contact Jian or submit an issue on github.

# Reference

- Zhao J., Wu J., Xu T., Yang Q., He J., and Song X.\*, 2018. IRESfinder: Identifying RNA Internal Ribosome Entry Site in Eukaryotic Cell using Framed K-mer Features. 2018, Journal of genetics and genomics= Yi chuan xue bao, 45(7), p.403.

Copyright (C) 2018 Xiaofeng Song.
