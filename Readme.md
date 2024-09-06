# Grading-Automation

This documentation explains the usage of two Bash scripts that automate the process of grading student submissions by extracting files and downloading lab inputs and outputs. The third section outlines future plans for automated testing.

## Table of Contents

- [1. Usage](#1-usage)
- [2. Overview of extract_zips.sh](#2-overview-of-extract_zips.sh)
- [3. Documentation for download_labs.sh](#3-documentation-for-download_labs.sh)
- [4. Automated Testing [TODO]](#4-automated-testing-todo)

---

## 1. Usage

### Prerequisites

Before running the scripts, ensure you have the following:

- **`.env` File**: Create a `.env` file in the same directory as the scripts with your credentials:
  ```bash
  SLI_USER=your_username
  SLI_PASS=your_password
  ```
  Replace `your_username` and `your_password` with your actual login credentials.

### Step 1: Extracting Student Submissions (`extract_zips.sh`)

1. **Place the Main Zip File**: Copy the main zip file containing all student submissions (e.g., `Lab1.zip`) into your current working directory.

2. **Make the Script Executable** (if not already):
   ```bash
   chmod +x extract_zips.sh
   ```

3. **Run the Script**:
   ```bash
   ./extract_zips.sh
   ```

4. **What Happens**:
   - The script searches for the first `.zip` file in the directory.
   - It extracts the contents into a folder named after the lab (e.g., `Lab1`).
   - Inside this folder, it creates a `submissions` directory.
   - Each student's submission is extracted into a separate folder within `submissions`, named in the format `LastName_FirstName`.

5. **Result**:
   - Organized student submissions ready for grading.
   - The main zip file and individual submission zip files are deleted after extraction to keep the directory clean.

### Step 2: Downloading Lab Input and Output Files (`download_labs.sh`)

1. **Ensure Credentials**: Verify that your `.env` file contains the correct `SLI_USER` and `SLI_PASS` variables.

2. **Navigate to the Lab Directory**:
   ```bash
   cd Lab1/
   ```
   Replace `Lab1/` with the appropriate lab directory if necessary.

3. **Make the Script Executable** (if not already):
   ```bash
   chmod +x download_labs.sh
   ```

4. **Run the Script**:
   ```bash
   ./download_labs.sh
   ```

5. **What Happens**:
   - The script reads the base URL and credentials from the `.env` file.
   - It processes both the `input` and `output` directories, downloading all files.
   - Downloads are saved as `.txt` files in their respective local directories (`input/` and `output/`).

6. **Result**:
   - All necessary lab input and output files are downloaded and organized.

### Notes

- **Error Messages**: If there are issues (e.g., no zip file found, incorrect file naming), the scripts will display informative error messages.
- **File Naming Conventions**: Ensure student submission files follow the `LastName, FirstName - ...` format for proper extraction.
- **Cleanup**: The scripts delete zip files after extraction to prevent clutter. If you need to keep the original zip files, modify the scripts accordingly.
- **Permissions**: Both scripts need execute permissions. Use `chmod +x script_name.sh` to set the necessary permissions.

### Example Workflow

1. **Prepare Environment**:
   - Place `extract_zips.sh`, `download_labs.sh`, and the `.env` file in your working directory.
   - Ensure the main zip file (e.g., `Lab1.zip`) is also in this directory.

2. **Extract Submissions**:
   ```bash
   ./extract_zips.sh
   ```
   - Submissions are extracted to `Lab1/submissions/`.

3. **Download Lab Files**:
   ```bash
   cd Lab1/
   ./download_labs.sh
   ```
   - Lab `input` and `output` files are downloaded into `Lab1/input/` and `Lab1/output/`.

4. **Proceed with Grading**:
   - Student submissions are ready and organized.
   - Lab files are available for reference or automated testing.

---

## 2. Overview of extract_zips.sh

The `extract_zips.sh` script is used to handle student submission zip files in a directory. It extracts, organizes, and cleans up student submissions in the following manner:

### Features:
- **Search and Extract**: The script searches for the first `.zip` file in the current working directory and extracts it.
- **Organize Submissions**: Inside the extracted main zip file, it processes each student's submission (if it follows the `LastName, FirstName - ...` naming format) by creating a folder for each student.
- **Cleanup**: After successfully extracting and organizing the files, the zip files are deleted to maintain a clean structure.

### Steps Involved:
1. **Find the main zip file**: The script finds the first `.zip` file in the current directory using `find`.
2. **Extract the main zip**: The extracted contents are organized into folders based on the student's name, which is extracted from the file names using regex.
3. **Delete zip files**: The main zip file and the individual zip files are deleted after extraction.

---

## 3. Documentation for download_labs.sh

The `download_labs.sh` script automates the process of downloading lab `input` and `output` files from a base URL, using credentials from a `.env` file.

### Features:
- **Base URL and Credentials**: The script reads the base URL and credentials from a `.env` file for HTTP authentication.
- **Directory Handling**: It processes the `input` and `output` directories by downloading files from the specified URL.
- **Automated Download**: A `download_from_directory` function is used to:
  - Fetch the list of available files.
  - Download each file and save it as a `.txt` file in the appropriate local folder (`input` or `output`).

---

## 4. Automated Testing [TODO]

This section is reserved for the future implementation of automated testing. Planned features include:

- **Unit Tests**: Validate that the `extract_zips.sh` script correctly handles file extraction, name parsing, and folder creation.
- **Integration Tests**: Ensure that files are downloaded correctly by the `download_labs.sh` script and that they match the expected format.
- **Error Handling**: Tests will simulate various error scenarios, such as missing files, invalid credentials, and malformed zip files, to ensure the scripts' robustness.
```