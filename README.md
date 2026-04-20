## DATA 550 Midterm Project Part 2 - Git Repository

Below are instructions for compiling the various versions of this midterm report, as well as a summary of these repository contents

# Instructions for compiling standard/default report

In order to generate the standard version of this report, follow these instructions below:
1. Using Terminal, navigate into the project directory
2. In Terminal, execute to the command `make install` to synchronize the package environment
3. In Terminal, execute the command `export WHICH_CONFIG="default"` to set the WHICH_CONFIG variable to the standard/default setting
4. In Terminal, execute the command `make` to build the report.

# Instructions for compiling customized/intervention report

In order to generate the customized version of this report, follow these instructions below:
1. Using Terminal, navigate into the project directory
2. In Terminal, execute to the command `make install` to synchronize the package environment
3. In Terminal, execute the command `export WHICH_CONFIG="intervention"` to set the WHICH_CONFIG variable to the customized/intervention setting
4. In Terminal, execute the command `make` to build the report.

# Repository Contents

Besides this README.md file, this repository also contains...

- the `code/` folder containing:
      - `00_clean_data.R`, which cleans our initial dataset based on the config specifications defined in terminal
      - `01_make_elements_1.R`, which creates the tables/figures used in section 1 of the report
      - `02_make_elements_2.R`, which creates the tables/figures used in section 1 of the report
      - `03_make_elements_3.R`, which creates the tables/figures used in section 1 of the report
      - `04_make_elements_4.R`, which creates the tables/figures used in section 1 of the report
      - `render_report.R`, which renders the report
- the `config.yml` file which defines the configs used to customize our two versions of the report
- the `data/` folder containing:
      - our initial dataset, `f75_interim.csv`
      - a cleaned version of the dataset (`cleandata.rds`) will also be saved here once created
- the Makefile contains commands to generate our report (both standard and intervention version) from Terminal:
      - `make report.html` will render the report based on the definition of the WHICH_CONFIG variable
      - `make cleandata` will clean the initial dataset based on the definition of the WHICH_CONFIG variable
      - `make install` will synchronize your machine's package environnment with this project
      - `make clean` will clean the project directory of .rds objects and .html files
      - a `make` command has also been written for each individual section of the report
- the `output/` folder, which will house whatever .rds objects we'd like to pull into our final version of the report
- the `renv/` folder containing;
      - an `activate.R` file
      - a `.gitignore` file
      - a `settings.json` file
- the `renv.lock` file, which stores information about the packages used to generate this report
- the `report.Rmd` file, which is used to compile our report

