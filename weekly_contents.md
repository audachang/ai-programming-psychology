Based on the course syllabus, here is a detailed breakdown of the weekly content designed to serve as a blueprint for generating structured Jupyter Notebooks or Python scripts.

The course follows a "methodological transformation" philosophy, moving from **Creation** (Experiments) to **Decoding** (Neuroimaging) and **Prediction** (AI).

---

### **Module 1: Foundations**

#### **Week 1: Python for Science & Open Science Setup**

* 
**Source Context:** Setup environment (Anaconda/VSCode), Git/GitHub, Numpy/Pandas.


* **Notebook Objectives:** Establish the "Reproducible Science" standard immediately.
* **Key Libraries:** `sys`, `numpy`, `pandas`, `git`.
* **Notebook Structure:**
1. **Environment Check:** Script to verify Anaconda installation and Python version ().
2. **Git Configuration:** Automate `git config` for user name/email and generate an SSH key for GitHub authentication.
3. **Numpy vs. Lists:** Performance comparison (vectorization vs. loops) to demonstrate why we use Numpy for data.
4. **Pandas DataFrames:**
* Creating a "mock" psychological dataset (Subject ID, Trial, RT, Accuracy).
* Basic cleaning: Handling `NaN` values and data typing.


5. **Assignment:** Initialize the class repository and push the first "Hello World" notebook.



---

### **Module 2: Experimental Design (PsychoPy)**

#### **Week 2: The Precise Stimulus – PsychoPy Basics**

* 
**Source Context:** PsychoPy basics, timing precision, visual rendering.


* **Notebook/Script Objectives:** Understand the "Frame-Based" timing loop crucial for cognitive science.
* **Key Libraries:** `psychopy.visual`, `psychopy.core`, `psychopy.monitors`.
* **Notebook Structure:**
1. **Window Creation:** Setting up a `visual.Window` with `fullscr=False` for testing.
2. **Stimulus Definition:** Defining `TextStim` (instructions) and `GratingStim` (Gabor patches).
3. **The While Loop:** The core concept of rendering:
* `stim.draw()`
* `win.flip()`


4. **Timing Drill:** Flash a stimulus for exactly 200ms using frame counting (assuming 60Hz, ).



#### **Week 3: Interaction & The Event Loop**

* 
**Source Context:** User responses, Stroop task, Assignment 1.


* **Notebook/Script Objectives:** Build a full logic flow: Stimulus → Response → Data Logging.
* **Key Libraries:** `psychopy.event`, `psychopy.data`, `pandas`.
* **Notebook Structure:**
1. **Trial Structure:** Define a list of dictionaries (e.g., `[{'color': 'red', 'text': 'BLUE', 'congruent': 0}, ...]`).
2. **Input Handling:** Using `event.waitKeys()` vs. `event.getKeys()` for reaction time collection.
3. **The Stroop Loop:**
* Iterate through trials.
* Display stimulus.
* Record keypress and calculating RT ().


4. **Data Logging:** Append trial data to a Pandas DataFrame and save as CSV.



#### **Week 4: Advanced Paradigms – Online & Adaptive**

* 
**Source Context:** Pavlovia, adaptive staircase procedures.


* **Notebook/Script Objectives:** Move from fixed designs to dynamic designs.
* **Key Libraries:** `psychopy.data` (StaircaseHandler).
* **Notebook Structure:**
1. **Staircase Logic:** Implement a simple "Up-Down" method (e.g., if correct, decrease contrast; if wrong, increase contrast).
2. **Visualizing Thresholds:** Plot the step-by-step difficulty changes to find the participant's perceptual threshold.
3. **JS Translation Prep:** Identify Python functions (like `os.path`) that break in PsychoJS and write JS-compatible alternatives.



---

### **Module 3: Neuroimaging (Neural Data Science)**

#### **Week 5: Intro to Neural Data (BIDS & fMRIPrep)**

* 
**Source Context:** BIDS format, Preprocessing pipelines.


* **Notebook Objectives:** Navigate complex directory structures and load NIfTI images.
* **Key Libraries:** `nibabel`, `nilearn`, `os`.
* **Notebook Structure:**
1. **BIDS Navigation:** Write a script to walk through a BIDS directory and identify subjects/sessions.
2. **Loading Data:** Use `nilearn.image.load_img` to load a preprocessed fMRI file.
3. **Visualization 101:** Use `nilearn.plotting.plot_anat` and `plot_epi` to inspect the brain volume.
4. **4D Structure:** Convert the image to a Numpy array to see the shape .



#### **Week 6: Signal Extraction (Masking & ROI)**

* 
**Source Context:** Masking, ROI extraction, Assignment 2.


* **Notebook Objectives:** Reduce 4D brain data to 2D matrices (Time  Region).
* **Key Libraries:** `nilearn.input_data`, `nilearn.datasets`.
* **Notebook Structure:**
1. **Atlas Loading:** Fetch the **AAL** or **Schaefer** atlas using `nilearn.datasets`.
2. **Masker Object:** Initialize `NiftiLabelsMasker` with cleaning parameters (standardize, detrend).
3. **Extraction:** `masker.fit_transform(fmri_img)` to get the time series.
4. **Plotting:** Visualize the signal of a specific ROI (e.g., Amygdala) over time.



#### **Week 7: Connectivity & Network Analysis**

* 
**Source Context:** Functional connectivity matrices.


* **Notebook Objectives:** Analyze how brain regions correlate with each other.
* **Key Libraries:** `nilearn.connectome`, `seaborn`.
* **Notebook Structure:**
1. **Correlation Matrix:** Calculate the Pearson correlation between all extracted ROIs.
2. **Heatmap:** Use `seaborn.heatmap` to visualize the connectivity matrix.
3. **Graph Theory (Optional):** Identify "hub" regions with high connectivity.



#### **Week 8: Midterm Project (Experiment Demo)**

* 
**Source Context:** Showcase of fully functional custom experiment.


* **Activity:** Live demo. No specific notebook generation, but students must submit their Github link.

#### **Week 9: MVPA – Decoding the Mind**

* 
**Source Context:** Multi-Voxel Pattern Analysis, Haxby dataset, Assignment 3.


* **Notebook Objectives:** Train a classifier to predict visual stimuli from brain voxels.
* **Key Libraries:** `nilearn.decoding`, `sklearn.svm`, `sklearn.model_selection`.
* **Notebook Structure:**
1. **Data Loading:** Fetch the Haxby dataset (Faces vs. Houses).
2. **Labeling:** Create a target vector  based on the experiment logs.
3. **Decoding:**
* Initialize `Decoder(estimator='svc')`.
* `decoder.fit(brain_data, target_labels)`.


4. **Evaluation:** Predict on a held-out run and calculate accuracy vs. chance ().
5. **Visualization:** Plot the "weight map" to see which voxels drove the decision.



---

### **Module 4: Machine Learning & Prediction**

#### **Week 10: ML Foundations (Regression & Classification)**

* 
**Source Context:** Scikit-learn basics, Overfitting, Cross-validation.


* **Notebook Objectives:** Understand the ML pipeline on standard behavioral data.
* **Key Libraries:** `sklearn`, `matplotlib`.
* **Notebook Structure:**
1. **Synthetic Data:** Generate simple linear data with noise.
2. **The Bias-Variance Tradeoff:** Fit polynomial regressions of increasing degree (1, 3, 20) to demonstrate overfitting.
3. **Cross-Validation:** Implement K-Fold CV to select the best model.
4. **Metrics:** Calculate MSE (for regression) and Accuracy/F1 (for classification).



#### **Week 11: Feature Engineering in Psychology**

* 
**Source Context:** Extracting predictive features from logs.


* **Notebook Objectives:** Turn raw logs (timestamps) into human features (fatigue, hesitation).
* **Key Libraries:** `pandas`, `scipy.stats`.
* **Notebook Structure:**
1. **Raw Data:** Load raw trial-by-trial log files from Assignment 1.
2. **Feature Creation:**
* *Micro-level:* Standard deviation of RT (Reaction Time Variability).
* *Trend-level:* Slope of RT over the session (Fatigue index).
* *Error-level:* Post-error slowing (RT on trial  if  was an error).


3. **Aggregation:** Create a "Subject-Level" table where one row = one participant.



#### **Week 12: Behavioral Prediction (UX & Marketing)**

* 
**Source Context:** Churn prediction, User segmentation, Assignment 4.


* **Notebook Objectives:** Solve an industry-style problem (e.g., Predicting Churn).
* **Key Libraries:** `sklearn.ensemble`, `sklearn.cluster`, `seaborn`.
* **Notebook Structure:**
1. **Dataset:** Load a user behavior dataset (e.g., App usage logs).
2. **Unsupervised (Clustering):** Use **K-Means** to group users into "Personas" (e.g., "Casual Browsers" vs. "Power Users").
3. **Supervised (Prediction):** Train a **Random Forest** to predict if a user will leave (Churn = 1).
4. **Feature Importance:** Visualize which behaviors are the strongest predictors of churn.



#### **Week 13: Deep Learning Intro (PyTorch)**

* 
**Source Context:** Neural Networks for complex patterns.


* **Notebook Objectives:** Introduction to tensors and simple neural nets.
* **Key Libraries:** `torch`, `torch.nn`.
* **Notebook Structure:**
1. **Tensors:** Explain PyTorch tensors vs. Numpy arrays.
2. **The Network:** Build a simple Feed-Forward Network (`nn.Linear`, `nn.ReLU`).
3. **Training Loop:** Manually write the forward pass, loss calculation, backward pass, and optimizer step.
4. **Application:** Apply to the dataset from Week 12 to see if it beats the Random Forest.



---

### **Module 5: Integration & Capstone**

#### **Week 14: Reproducible Science (Docker)**

* 
**Source Context:** Docker, CI/CD, Publication standards.


* **Notebook/File Objectives:** Create the configuration files needed to share the work.
* **Files to Generate:**
1. **`requirements.txt`**: Freezing library versions.
2. **`Dockerfile`**: Writing a script to build a container with Python, FSL, and necessary libraries.
3. **`README.md`**: Structuring a professional project description (Abstract, Installation, Usage).



#### **Week 15: AI Capstone Studio**

* 
**Source Context:** Group work on final projects.


* **Activity:** Instructor office hours and code debugging. No new content.

#### **Week 16: Final Project Showcase**

* 
**Source Context:** Poster session and presentation.


* **Activity:** Final presentations.

---
