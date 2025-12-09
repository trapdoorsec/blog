+++
title = "OWASP Top Ten - 20 years of Application Security"
date = "2025-11-27"
[taxonomies]
tags = ["cybersecurity", "Appsec", "history", "thot leaderizing"]
+++

# 20 Years of Application Security

Looking at the OWASP Top 10 2025 Release Candidate recently made me feel... old. Not the "I'm getting grey beard hair" kind of old, more like the "I remember when this list first came out", kind of old. Ok maybe a little with the grey hair.

To paint the picture for those who may not recall 2004: We had just landed the rovers on Mars, Usher & Maroon 5 were a permanent fixture on the US charts, the dot-com bubble hangover was lifting, the memory of 9-11 was fresh in peoples minds and we had the global conflicts to show for it.

In cybersecurity, we were witnessing a shift. That January, the MyDoom mass emailer worm caused approximately $38 billion in damage globally - and variants would be seen in the wild for nearly five years. Symantec reported[2] a 366% increase in phishing and predicted that it would continue to rise - and they were right. Significantly, they also spotted that well over 40% of vulnerabilities documented between July 1 and Dec 31 of 2004 were web application vulnerabilities, an increase of 39% over the previous 6 months. This was a disturbing trend given we were betting the farm on web applications.

This was the backdrop when OWASP released their Top 10 Web Application Security Risks, version 2. It was meant to be a snapshot of the most critical vulnerabilities we faced.

---
## Whats changed since then?

Fast forward to today and the trends in cybersecurity sound very different yet feel vaguely familiar:

- The concept of phishing - fooling people into clicking on a malicous link via email - has expanded to target the supply chain and other vectors: smishing, vishing, domain squatting, poison packages on npm, malicious browser in browser fakery etc. It gone from spray and pray to poison the well.
- AI powered social engineering augments the efforts of those executing the above attacks - its now possible to fake a voice or even video feed.
- Desktop viruses of old have given way to cloud misconfigurations
- Those script kids of 2004 have levelled up and become randomware-as-a-service operators, further lowering the barrier to entry for new miscreants to play dirty

And finally, web apps have only increased their importance, with API and microservices, alongside OAuth and OIDC encouraging machine integration over the internet.

### OWASPs Top Ten over time
For the unintiated, this awesome community effort strives to collate quality data about the nature of web application cybersecurity attacks and publish them to web developers worldwide for free. I highly recommend being aware of its contents at all times if you're in the business of web application development in any capacity.

When we compare how the OWASP Top Ten has evolved it provides us an interesting window into not only how attacks have evolved, but how we've responded.

![](/img/owasp-compare.png)
_source: my own diagram in whimsical, derived from historical OWASP content and the latest version 8 RC1_

### There is an "I" and "A" in "CIA"? Who knew?

For decades, developers treated Integrity and Availability as "operations problems" - write the code, throw it over the fence, let ops deal with the logs and uptime. That DevOps-shaped hole in our security posture is exactly what we're still trying to fill with CI/CD.

Something shifted around 2017. OWASP added "Insufficient Logging & Monitoring" to the Top 10, essentially telling developers that 'your job doesn't end when the code compiles'. Good logs are a love letter to your support teams and incident responders. Design observability as a feature, not an afterthought.

By 2021, this evolved further with "Software and Data Integrity Failures" entering at #8. Now we're not just asking "can you detect when you're breached?" but "can you prove your build pipeline hasn't been compromised?"

> An insecure CI/CD pipeline can introduce the potential for unauthorized access, malicious code, or system compromise.
— _OWASP Top 10 2021, A08: Software and Data Integrity Failures_

In 2025 we're being much more prescriptive: use integrity checks for artifacts, please!

> An insecure CI/CD pipeline without consuming and providing software integrity checks can introduce the potential for unauthorized access, insecure or malicious code, or system compromise.
— _OWASP Top 10 2025RC1, A08: Software and Data Integrity Failures_

Translation: Supply chain security isn't optional anymore. If you can't verify what went into your build, you can't trust what came out of it.

The pattern: We spent 20 years perfecting Confidentiality (encryption, access control). We're finally realizing that data you can't trust or systems you can't observe are just as dangerous as data you can't protect.

### Buffer overflows have operating system level mitigations now
Buffer overflows (aka BOFs), once the bain of the C/C++ programmer, were a significant issue, mainly due to the duopoly that was Apache and IIS web servers in the wild. This kind of attack would be a critical remote code execution issue - many inexperienced web server admins would also run apache or IIS with a high level of privilege out of laziness and lack of awareness.

Today, not only are more webservers likely to run managed code (i.e. safe from buffer overflows by design), operating systems have stack protections that can randomize memory layout (ASLR), dynamic execution prevention and the like, making those BOFs much header to take advantage of should they exist.

### Supply chain attacks emerged

We built websites very differently too, in 2004 the concept of `npm install leftpad` simply didn't exist. Sharing code happened via blogs and dedicated code sharing sites, which in theory could have been a vector, but the reality is that they weren't used in the kind of capacity as a package would be leveraged in 2025.

Today there are over 400k npm packages alone. This makes for a juicy target. In 2019 we all learned that a mere 20 compromised package maintainers on NPM could potentially infect over 50% of the entire ecosystem practically overnight - making for a very juicy target. [5]

This trend continues with the discovery of developer targeting malware like [glassworm](https://www.bleepingcomputer.com/news/security/self-spreading-glassworm-malware-hits-openvsx-vs-code-registries/) via marketplaces for our text editors, of all things. Notably, glassworm channels the bad old days of MyDoom's wormable nature.

### AI, obviously

You might be surprised that there is nothing related to AI or LLM's in the OWASP Top 10. Well, good news!

Because its such a unique space, the OWASP organization has given it a Top Ten all it's own: https://genai.owasp.org/llm-top-10/ and you will note that its number one issue is... you guessed it ... prompt injection!


## The uncomfortable constants

What's stayed the same? In 2004, 70% of vulnerabilities were classified as easily exploitable, and 97% were considered moderately or highly severe prwire. [2]

In 2025? The numbers are actually worse. Roughly 38% of reported vulnerabilities in 2025 are rated High or Critical severity (CVSS ≥7), Early 2025 actually saw a spike in Critical CVSS 9+ vulns compared to prior years.[3]

 While in 2024, 42% of analyzed vulnerabilities had publicly available proof-of-concept exploits, significantly reducing the technical barrier for cybercriminals.[4]

At least by this yardstick, in 20 years we have little to show for our attempts at securing technology. We've definitely gotten better at distributing the same problems across more complex infrastructure though.

## Access controls - still broken

Broken access control is #1 on the OWASP Top 10 for a reason. As an industry, the economics of web development forced us to tackle the phishing problem first - identity and authentication (AuthN) get the budget and attention. Passkeys might finally kill credential theft. Cool.
But authentication is the easy problem. Authorization (AuthZ) is where we keep failing.
The reality? All the YubiKeys and passkeys in the world won't save you if a new user can access your admin panel by tweaking a role in their JWT.
If anyone can view customer data by incrementing an ID in the API call then its all for naught.

Perhaps, we're close to getting "who are you?" right, but we still can't consistently answer "what are you allowed to do?".

## Injection still works :/

What's fascinating about injection vulnerabilities is that we keep making this mistake. Just as we've wrapped our heads around the ramifications of a given query technology, we invent a new one with a whole new set of injection primitives to worry about:

- 2004 - SQL databases were the norm → SQLi was rampant
- 2010 - XML-RPC was common → XXE attacks emerged
- 2015 - NoSQL databases became mainstream → NoSQL injection appeared
- 2020 - GraphQL was everywhere → We stacked NoSQL injection with GraphQL-specific query manipulation
- 2025 - LLMs are in production → Prompt injection, RAG poisoning, and indirect prompt injection are the new frontier

The underlying problem never changed: we're still concatenating untrusted input into interpreters. We just keep inventing new interpreters. In 2004, it was `"SELECT * FROM users WHERE id=" + userInput`.
In 2025, it's `f"Answer this question using the following context: {userInput}"`. Same vulnerability. Different syntax. We learned to parameterize SQL queries, but forgot the lesson when we moved to NoSQL, GraphQL, and now AI prompts.

---

# Conclusion: What Does This Mean Beyond 2025?

Twenty years of OWASP Top 10 data tells us something uncomfortable: **we're not getting better at the fundamentals.** We're getting better at building complex systems that distribute the same old vulnerabilities across more layers.

Will AI in the form of LLM based tools help us? That remains to be seen, however I remain sceptical of this, given that broken access control is still at the top. BAC issues stem from a lack of understanding or testing of the business rules unique to the application being built - that is to say, you can't prompt for what you don't know to ask for in the first place, and the LLM won't inherently detect every single RBAC rule your organization has come up with, at least not unless the LLM has direct access to that information - which seems unlikely to me. I think this is why humans will still be involved heavily in creating software well into the future.

## For Defenders

The good news is that the appsec playbooks from 2004 largely still work. SQL injection prevention, access control validation, input sanitization—these aren't outdated techniques. They're eternal truths we keep forgetting.

The challenge is you now need to apply those fundamentals across:
- 50 microservices
- 400 npm dependencies
- 12 cloud services
- AI prompts that look like natural language but behave like SQL queries

### Actionable advice
- **Shift left, but verify right:** DevSecOps is great, but runtime monitoring caught SolarWinds, CodeCov, and dozens of supply chain attacks that passed all the CI checks
- **Assume compromise in your dependencies:** Pin versions, use SBOMs, monitor for behavioral changes
- **Log like someone's life depends on it:** Because in healthcare, finance, and critical infrastructure, it actually might.

## For Developers

You've inherited 20 years of technical debt disguised as "best practices." From one of the old guard - I am sorry.

The uncomfortable truth, that npm package you installed? You're trusting 79 third-party packages and 39 maintainers on average. That GraphQL endpoint? It's just SQL injection with extra steps. That LLM feature? It's user input concatenation all over again.

### First Principles still matter
- **Understand, don't just use:** Frameworks protect you until they don't. Know why parameterized queries work, not just how to use an ORM
- **Treat AuthZ like AuthN:** You wouldn't skip password validation. Stop skipping resource ownership checks
- **Your code will be attacked:** Design with that assumption. Write logs that help future-you during an incident at 3 AM
- **Supply chain hygiene:** Review your dependencies like you review your own code. That leftpad incident wasn't a fluke—it was a warning

**The mantra:** If you're concatenating user input into *anything* that interprets it—SQL, NoSQL, GraphQL, shell commands, prompts—you're probably doing injection wrong.

## For Leadership

Here's what 20 years of data actually tells you:

**1. Security isn't getting easier**

You can't "buy security" - never could. That SAST tool, WAF, or SIEM? They're necessary, but insufficient. Security is about your people:
- Developer training (they're shipping the vulns)
- Architecture decisions (microservices = more attack surface)
- Supply chain verification (your code is 5% of your application)
- Incident response and threat hunting capabilities (you will be breached, but can you detect it?)

**2. The fundamentals haven't changed, but the economics have**

In 2004, a breach meant some bad press. In 2025, it means:
- GDPR/DORA/CCPA/HIPAA fines (4% of global revenue)
- Class action lawsuits
- Ransomware payments
- Supply chain liability (you breached your customers too)
- Millions wiped off stock prices overnight

The ROI on basic security hygiene has never been higher.

**3. Your developers are your security team (whether you like it or not)**

Every line of code is a security decision. Every dependency is a trust decision. Every API endpoint is an attack vector. You can hire all the security engineers you want, but if your 50 developers ship 1,000 commits per week, security-by-review doesn't scale.

**Investment priorities:**
- **Training:** Not compliance checkbox training. Real, practical secure coding for your stack
- **Tooling:** SAST/DAST/SCA that developers actually use (not just buy)
- **Culture:** Making security a feature requirement, not a post-release patch
- **Observability:** You can't defend what you can't see. Log aggregation, SIEM, and actual human analysis

## Call to Action: How Does Your Application Stack Up?

Here's your mission if you choose to accept it.

1. **Take 30 minutes:** Walk through the [OWASP Top 10 2025 RC1](https://owasp.org/Top10/) and honestly assess which apply to your application
2. **Check your dependencies:** Run `npm audit` or equivalent. How many HIGH/CRITICAL vulns are you shipping?
3. **Test your logging:** Simulate an attack. Can you detect it? Can you trace it? Can you respond to it?
4. **Review your CI/CD:** Can you prove what went into your last build? Do you have integrity checks?
5. **Audit one critical endpoint:** Pick your most sensitive API. Check for:
   - Broken access control (can user A access user B's data?)
   - Injection vectors (are you sanitizing/parameterizing inputs?)
   - Logging (would you know if this endpoint was being abused?)

**Then ask yourself:** If this application were breached tomorrow, would we:
- Know about it within hours (not months)?
- Understand how they got in?
- Be able to prove what data was accessed?
- Have a response plan that doesn't start with "panic"?

If you answered "no" to any of those, start with the OWASP Top 10. It's been telling us the same story for 20 years.

## A Final Thought

The OWASP Top 10 isn't a prediction of the future. It's a reflection of our past.

Buffer overflows dropped off not because we got smarter, but because we moved to languages that wouldn't let us make that mistake. SQL injection is still #3 not because it's hard to prevent, but because we keep forgetting to prevent it.

**That's up to us.**

---

*Thanks for reading. If you found this useful, consider sharing it with your team. And if you're working on securing applications, you're not alone—the OWASP community is there to help. Check out [https://owasp.org](https://owasp.org) for resources, tools, and that Top 10 list we've been talking about.*

*Stay safe out there. And for the love of all that is holy, **parameterize your queries.***

===================

References:

- [1 - MyDoom History](https://www.okta.com/identity-101/mydoom/)
- [2 - Symantec threat report for 2004](https://prwire.com.au/pr/4412/symantec-internet-security-threat-report-highlights-rise-in-threats-to-confidential-information)
- [3 - Deepstrike Vulnerabilities Statistics 2025: Record CVEs, Zero-Days & Exploits](https://deepstrike.io/blog/vulnerability-statistics-2025)
- [4 - Blackite Vulnerability Trends and Statistics](https://content.blackkite.com/ebook/2025-supply-chain-vulnerability-report/trends-and-statistics)
- [5 - ZDnet article](https://www.zdnet.com/article/hacking-20-high-profile-dev-accounts-could-compromise-half-of-the-npm-ecosystem/)


