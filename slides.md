---
marp: true
theme: uncover
paginate: true
header: Oliver Woolland - Workflows: a user perspctive
footer: RSE Show and Tell, March 2025
---

### **Workflows**: a user perspective
### Oliver Woolland (RSE, 2025)

---

# What is a workflow?

---
### My answer ~2022:

#### **Formalised chains of software tools, explicitly defining the flow of data between them.**

- **Abstract**: logic separate to data, remix / compose
- **Automated**: reusable, reproducible, provenance
- **Scalable and portable**: local / HPC, Windows / Linux
- **Shareable and citable**: publishable, create DOIs

---

## What is a workflow *for a user?

Workflows are really about:
- **Enabling research** not installing tools 
- **Doing research** not manually running tools
- **Accelerating research** using HPC / cloud
- **Sharing research** not just reports and papers

---

![bg fit](./overall_workflow.png)

---

## So what changed?

I became familiar with Galaxy!

(and spent more time with researchers)

--- 

## Why Galaxy changed my mind?
<style scoped>
section {
    font-size: 30px;
}
</style>

⛔ Installing a framework / tool / docker / plugin
✅ Just use your browser
####
⛔ Installing tools
✅ Just use your browser
####
⛔ YAML / Python / text editor faffing
✅ Just use (the GUI) in your browser
####
⛔ "Yeah you can use my workflow! Clone this repo, install this tool, configure this library, download this file"
✅ "Just go to [your URL] in your browser"

---

### "But my workflow engine is **better** 😤"

Well, maybe. But as a group we should pick one.

List of 361 workflow engines:
https://github.com/common-workflow-language/common-workflow-language/wiki/Existing-Workflow-systems

---

## Why Galaxy is good enough

- Administered by sysadmins not users
- Browser interface is best for users
- Can interfce with HPC
- Has an API
- Actively developed
- Widely adopted

---

# **Can I prove Galaxy is good enough?**

### I think so! 
Let's look at a worked example

---

# Introducing: some linguists

- **Alice** (Masters student) saw a tool online
- **Bob** (PhD student) knows a tool from the literature
- **Charlie** (Postdoc) too busy but has big ideas
- **Dani** (PI) wants research to occur, to show off
- **Me** (pretending to be a sysadmin)

#### Their research aim: 
**To mine data from a database of phrases**

---

## Demo

### Time for chaos

--- 

# What did we see?

- Researchers doing research! 
- Without any setup
- Using tools, making workflows, sharing output

---

## Galaxy's big questions (and my solutions)
<style scoped>
section {
    font-size: 28px;
}
</style>

### **Doesn't Galaxy needs a server to set up and maintained?**

### **Doesn't Galaxy make it hard to do local development?**

I thought this for a long time but now have an answer!

Clone this repo for an example **self hosted Galaxy using Docker**

### **Wont the Galaxy server die at the end of my project?**

Well...

---

## My suggestion

We trail a persistant, central Galaxy instance for RSEs

We put a workstationx *under a desk*

RSEs doing workflow projects see if Galaxy fits their needs and contribute tools

---

## The future

If the instance too popular and a workstation can't cope:
- Good problem to have!
- Can investigate backing on to HPC / cloud

If it is not:
- Nice workstation for someone

---

## Conclusions

- Workflows should be about:
  - user experiences
  - enabling research
- Galaxy is good enough 

## We should (gently) start to host our own Galaxy

---

Let's have a look at a tool

```xml
<tool id="letter_count" name="Letter Count" version="0.1.0">
  <description>Counting letters in a string</description>
  
  <requirements>
    <container type="docker">python:3.13-slim</container>
  </requirements>
  
  <command>
    <![CDATA[
      python '$__tool_directory__/letter_count.py' '$input_str' '$output_file'
    ]]>
  </command>

  <inputs>
    <param type="text" name="input_str" label="Input String" help="Enter the string to count the letters" />
  </inputs>

  <outputs>
    <data format="txt" name="output_file" label="Letter Count" help="Output file containing the letter count" />
  </outputs>
  
  <help>
    This tool counts the number of letter in each word of a string.
  </help>

</tool>
```
