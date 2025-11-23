# Reverse Engineering a Password Checker | Complete Methodology Walkthrough

## **HOOK (0-15 seconds)**
*[Show binary executable on desktop, mysterious and intimidating]*

**"Imagine, you've got a program running on your computer. It asks for a password, but you don't know that password. 
But in the next 15 minutes, I'm going to show you how to extract the password from a badly written program, using nothing but reverse engineering techniques."**

*[Dramatic pause, show tools launching]*

**"Welcome to reverse engineering 101."**

## **INTRO/SETUP (15-45 seconds)**

*[Show channel intro]*

**"Welcome to the Trapdoor Security channel folks. Seska here, and today we're going to make use of the virtual machine that 
we setup to take our first baby steps into the binary reverse engineering process."**

*[Show the challenge setup - generic password checker]*

**"This is what we call a 'crackme' or reverse engineering capture the flag challenge - a program designed specifically to test your reverse engineering skills. Perfect for learning the methodology without any ethical concerns."**

**"By the end of this video, you'll understand not just how to solve this specific challenge, but the systematic approach that works on any binary you encounter."**

## **THE METHODOLOGY OVERVIEW (45s-2:00)**

*[Show flowchart/methodology diagram]*

**"Before we touch any tools, let's talk methodology. Reverse engineering isn't about randomly clicking buttons in a disassembler - it's a systematic process with clear steps:"**

*[Steps appear on screen]*

### **Phase 1: Reconnaissance**
- File type and basic properties
- String analysis
- Import/export analysis

### **Phase 2: Static Analysis**
- Disassembly and code flow
- Function identification
- Algorithm understanding

### **Phase 3: Dynamic Analysis**
- Runtime behavior
- Memory analysis
- Input/output tracing

### **Phase 4: Synthesis**
- Putting it all together
- Solution development
- Verification

**"Each phase builds on the previous one. Skip a step, and you'll miss critical information. Let's see this in action."**

## **PHASE 1: RECONNAISSANCE (2:00-4:30)**

*[Show file properties, command line tools]*

**"Step one - know your target. We start with basic file analysis:"**

### **File Properties**
```bash
file password_checker
# Output: ELF 64-bit LSB executable, x86-64, dynamically linked
```

**"64-bit Linux executable. Good to know - this tells us our disassembler settings and what calling conventions to expect."**

### **String Analysis**
*[Show strings command output]*

```bash
strings password_checker | grep -i pass
# Look for: password prompts, success/failure messages, hints
```

**"String analysis often gives away the most secrets. We're looking for:"**
- Password prompts and error messages
- Hardcoded strings that might be keys
- Function names that weren't stripped
- Any debugging information left behind

### **Import Analysis**
*[Show library dependencies]*

```bash
ldd password_checker
objdump -T password_checker
```

**"What libraries does it use? strcmp? encryption functions? This tells us what algorithms we might encounter."**

**"Already, without opening a disassembler, we know:"**
- Target architecture and OS
- Likely programming language
- What external functions it calls
- Potential hints from visible strings

## **PHASE 2: STATIC ANALYSIS (4:30-8:00)**

*[Launch disassembler - Ghidra/IDA/radare2]*

**"Now we dive deep. I'm using [tool name] because it's [free/powerful/etc], but the principles apply to any disassembler."**

### **Entry Point Analysis**
*[Show main function or entry point]*

**"First stop - the entry point. In C programs, this is usually main(). Here's what we see:"**

*[Show disassembly with annotations]*

```assembly
; Simplified example - not actual output
push    rbp
mov     rbp, rsp
sub     rsp, 0x20           ; Local variables
lea     rdi, aEnterPassword  ; "Enter password: "
call    puts
```

**"The program is setting up a stack frame and calling puts to print a prompt. Standard stuff."**

### **Control Flow Analysis**
*[Show flow graph/branching]*

**"Here's where it gets interesting. After reading input, we see a branch:"**

```assembly
call    check_password      ; Our target function!
test    eax, eax           ; Check return value
jz      failure_path       ; Jump if zero (failure)
; Success path continues here
```

**"The key insight: there's a separate function called 'check_password'. That's our target."**

### **Password Checking Function Deep Dive**
*[Show detailed function analysis]*

**"Let's examine check_password step by step:"**

*[Walk through each instruction with explanation]*

**"What we're looking for:"**
- How it processes our input
- What it compares against
- Any transformations or encryption
- The exact success condition

## **PHASE 3: DYNAMIC ANALYSIS (8:00-12:00)**

*[Show debugger setup - gdb/x64dbg]*

**"Static analysis tells us what the code CAN do. Dynamic analysis shows us what it ACTUALLY does with our input."**

### **Breakpoint Strategy**
*[Set breakpoints at key locations]*

**"Strategic breakpoint placement:"**
- Entry to check_password function
- Before any comparison operations
- At success/failure branches
- Any string manipulation functions

### **Execution Tracing**
*[Show step-by-step debugging]*

**"Let's trace through with a test password 'test123':"**

*[Step through execution, showing register values]*

**"Watch the registers:"**
- RSI contains our input string
- RDI contains what it's comparing against
- The comparison result determines the branch

### **Memory Analysis**
*[Show memory dumps at key points]*

**"Here's the beautiful moment - we can see both strings in memory:"**

```
Our input:    "test123"
Target:       "sp00ky_p4ss!"  ; Example - not real solution
```

**"The program is doing a simple strcmp comparison. We've found our answer!"**

## **PHASE 4: SYNTHESIS & SOLUTION (12:00-14:30)**

*[Show solution process]*

**"Now we put it all together. Based on our analysis:"**

### **What We Learned:**
1. Program uses simple string comparison
2. No encryption or obfuscation
3. Target password stored in plaintext
4. Success condition is exact match

### **Solution Development:**
*[Show testing the discovered password]*

```bash
./password_checker
Enter password: sp00ky_p4ss!
Success! You've cracked the password!
```

### **Verification:**
**"Always verify your understanding by testing edge cases:"**
- What happens with wrong passwords?
- Are there multiple valid passwords?
- Is case sensitivity important?

## **ADVANCED TECHNIQUES & VARIATIONS (14:30-17:00)**

*[Show more complex scenarios]*

**"Real-world binaries aren't always this simple. Here are variations you'll encounter:"**

### **Obfuscation Techniques:**
- **String encryption** - Passwords XOR'd or encoded
- **Control flow obfuscation** - Fake branches and dead code
- **Anti-debugging** - Detection of analysis tools
- **Packing** - Compressed/encrypted executables

### **Advanced Analysis Methods:**
- **Symbolic execution** - Tools like angr for complex logic
- **Emulation** - Running code in controlled environments
- **Side-channel analysis** - Timing and power analysis
- **Patch analysis** - Modifying binaries to bypass checks

*[Show examples of each technique]*

**"The methodology stays the same, but the tools get more sophisticated."**

## **TOOLS & RESOURCES (17:00-18:00)**

*[Show tool recommendations]*

### **Free Tools:**
- **Ghidra** - NSA's disassembler, incredibly powerful
- **radare2** - Command-line RE framework
- **GDB** - Linux debugger
- **Strings, objdump, file** - Basic analysis tools

### **Commercial Tools:**
- **IDA Pro** - Industry standard (expensive)
- **Binary Ninja** - Modern alternative
- **x64dbg** - Windows debugging

### **Learning Resources:**
- Practice platforms (HackTheBox, OverTheWire)
- Academic courses (Reverse Engineering for Beginners)
- CTF competitions
- Open source malware samples (for advanced practice)

## **ETHICAL CONSIDERATIONS (18:00-18:30)**

*[Serious tone, clear messaging]*

**"Important note: These techniques are for educational purposes, authorized testing, and legitimate security research only. Never use these skills on software you don't own or don't have explicit permission to analyze."**

**"Good reverse engineering helps improve security. Use these powers responsibly."**

## **CLOSING & NEXT STEPS (18:30-20:00)**

*[Show subscribe reminder, related content]*

**"We've just walked through the complete reverse engineering methodology - from initial reconnaissance to final solution. This same process works whether you're analyzing malware, cracking challenges, or understanding how your own software works."**

**"The key takeaways:"**
1. **Follow a systematic methodology** - Don't skip steps
2. **Use multiple analysis techniques** - Static and dynamic complement each other
3. **Document everything** - You'll forget the details later
4. **Practice regularly** - These skills need constant reinforcement

**"What would you like to see next? More reverse engineering tutorials? Different types of challenges? Advanced techniques like unpacking or anti-debugging bypass? Let me know in the comments."**

**"If this walkthrough helped you understand the RE process, make sure to subscribe - I'm planning a whole series on reverse engineering techniques, from beginner challenges like this to advanced malware analysis."**

**"Until next time, remember: every binary has secrets. With the right methodology, you can uncover them all."**

*[Show end screen with related videos]*

---

## **PRODUCTION NOTES:**

### **Screen Recording Needs:**
- Terminal work (file analysis, strings, etc.)
- Disassembler interface (function graphs, assembly code)
- Debugger sessions (stepping through code)
- Memory dumps and register values
- Before/after comparisons

### **Visual Elements:**
- Methodology flowchart
- Assembly code with annotations
- Memory layout diagrams
- Tool comparison charts
- Progress indicators for each phase

### **Engagement Strategies:**
- "Pause here and try it yourself" moments
- "What do you think this instruction does?" questions
- Tool preference polls in comments
- Challenge suggestions from viewers

### **Series Potential:**
- Different challenge types (crypto, patching, unpacking)
- Platform-specific techniques (Windows vs Linux)
- Advanced topics (kernel debugging, firmware analysis)
- Malware family deep-dives