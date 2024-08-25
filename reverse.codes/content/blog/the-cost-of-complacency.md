+++
title = "The Cost of Complacency: Why 'Secure by Default' Isn't Just Nice to Have."
date = "2024-08-26"
[taxonomies]
tags = ["cybersecurity", "product design", "secure by default"]
+++

In an era where cyber threats loom larger than ever, being a good global citizen means prioritizing not just functional 
software but also security by design. _Security is an expected function._

![stock-secure_lock.jpeg](/img/stock-lock.jpeg)
---

# Software isn't difficult, humans are.

You know that overused [joke in software circles](https://martinfowler.com/bliki/TwoHardThings.html) about there being two 
hard things? Well, one of those things, 'naming things' I feel extends to _defining things_, because this is where software's 
value actually lies: the interpretation and delivery of human requirements, which are notoriously difficult to pinpoint sometimes.

Example time, "Make the car drive autonomously" might look like a requirement to the average person, but in fact it is more of a _desirement_
because it doesn't adequately express the complexities involved such that two different designs would both meet 
a standard. Did you mean safely? What does that mean? Should it drive on the left or the right side of the road? Oh it's country 
dependant? How will it know, oh so it needs GPS. Right. What if that fails? *

So we need to understand, that to a product team, saying 'secure by default plzkthxbai' is really just a way of being annoying and 100% 
non-constructive. They _know_ it's a good idea, just... how?

# Why do we even care about secure by default?

OK so, I'll admit, if somebody says to me that secure by default is not a priority, I get a bit hot-blooded. It makes me want
to lean into the fact that I'm a grumpy old man and tell the war stories again. 

Reality is though, people clutch their pearls every time something awful happens, but nothing materially changes the status quo.

## The Morris Worm incident
In 1988, an enterprising young student named Robert created what he thought was a harmless experiment to measure the size of 
... um... the internet. 

![Robert Morris relaxing at his computer drinking a coke](https://www.vice.com/wp-content/uploads/sites/2/2017/10/1508840382333-robert-morris-primo-worm.jpeg)

However, His program relied on a default password and a buffer overflow vulnerability in the canonical email service of the day: `sendmail` - a Unix program.

He designed a self replication component to his program, and before he could say 'off by one error' he had infected around 10% of 
the internets servers at the time (approx 6000 machines), and caused millions of dollars damage in lost productivity.

This moment was pretty significant, in that it hadn't really happened on this scale before, but it also perfectly demonstrates
why having insecure defaults opens us up to one of the nastiest types of malware: the worm - a self replicating program 
capable of spreading itself without user interactions.

## The Code Red Incident

Another example: we used to be OK with Windows Server 2003 leaving port 445 (SMB protocol) open on install. Code Red made
especially good use of this fact - some of you will remember - their cyberattack of 2001 which targeted another default
configuration in IIS (open port 80). 24 hours, 350000 servers brought to their knees, billions in lost productivity. (Moore, Shannon, Klaffy 2002)

You can see where the product design decisions come from: make the internet easy to play with! Make networking easy! Minimize the clicks
a server admin needs to take in order to 'get online'! All laudable, money making ideas. Entirely insecure.

Alas, these weren't entirely addressed until 5 years later, in Windows Server 2008 as Microsoft now had the 'very insecure'
label that they probably wanted to shake.

## Fast forward to 2024: IPv6 has the same problem
It has recently been revealed that [IPv6 had a vulnerability](https://www.theregister.com/2024/08/14/august_patch_tuesday_ipv6/), causing concern among IT professionals.

The reason for this is that it also is 'wormable'. Why is that? How can a bug in an internet protocol do that, when there was
no default password?

In this case, the issue is that many devices and indeed operating systems, enable IPv6 by default, _even though they don't strictly need it_. Combine that fact with
the remote code execution vulnerability in IPv6, and suddenly, we have a worm.

## Conclusion: Water is wet and investors don't care.

All this did not ruin Microsoft, Unix still exists today, SMB is still a protocol that is used.
So, none of the impacts where so bad that humanity cancelled them from all relevance. This tale is repeated in the Solarwinds
breach and Crowdstrike outages of late. Go have a look at Crowdstrike share price, I dare you.

![CRWD stock price showing their almost immediate recovery from perhaps the biggest outage in IT history](/img/CRWD-stock-price.png)

Now look at Equifax.

![EFX stock price showing their continued rise in value since a massice databreach in 2017](/img/EFX-stock-price.png)

It would seem that lost productivity makes for a good (bad?) news story, but as a society, I don't think we value it as much as
journalists would have you believe. **Surely, we move to fix things all-proper-like when people die though, right?** 

_Right?_

[Stuxnet](https://en.wikipedia.org/wiki/Stuxnet), [WannaCry](https://en.wikipedia.org/wiki/WannaCry_ransomware_attack#Affected_organisations), Ransomware in general, heck arguably, even the old [Therac-25 Radiation Therapy Machine](https://en.wikipedia.org/wiki/Therac-25#Root_causes) of the 1980s were all situations
where human lives could have been, if not were, affected because of insecure by design or other design flaws we would consider
to be security adjacent. 

So no, fact is, when it all comes down to the cold hard math of making said crusts, people (not just 'big evil companies' I might add),
put their earning potential ahead of all else. 

# This is extremely short-sighted

At the moment we enjoy relatively cheap technology, maybe a few more ads than I'd like, but for those with enough means 
to purchase a device, much of the software you need to make your life easier is near enough to free.

The thing that does change though, is the rate at which we embed technology into the critical parts of our lives. This is a given.

In order to protect lives, we are now looking at the alternative solution to businesses regulating themselves. Of course, 
I mean governments doing the regulation bit. And this will make everything more expensive.

# Where businesses fail to act, governments step in
Remember when cars didn't have seat belts? OK, so I don't either, but that was a big issue in the 60s, people were dying enough that [Ralph Nader wrote a book about it](https://www.youtube.com/watch?v=vTnWMnLJqT8).

That led to loads of litigation and then government regulation, and finally, a massive increase in saftey. 

It also added well over 10% to the price of a car, depending on what sources you refer to. Could businesses have avoided this? Could cars have been cheaper and safer?

So given the above, in my opinion, tech companies will have their 'Ralph Nader' moment in the future, and until then, things aren't likely to change.

# The US Government is actually doing something meaningful to prevent the repeat of history
Enter the [CISA recommendations of 2023](https://www.cisa.gov/resources-tools/resources/secure-by-design), which is the first attempt at
a government (that I'm aware of, at least), that tries to properly define 'secure by design'.

The subtext is often missed though. CISA is trying to give us all a massive hint: "start doing these things before we force you to do them."
They know that the lawsuits are coming, [governments are even enabling them](https://www.sec.gov/newsroom/press-releases/2023-139), as one of the biggest customers of technology, this makes perfect sense.

# What if we adopted the CISA recommendations then...

Alright, so you want to be a good global citizen and make software that is secure by design? First up. Thankyou, for trying to
play the long game, and make software cheaper for everyone by raising the bar and customers expectations!

> There is no single solution to end the persistent threat of malicious
cyber actors exploiting technology vulnerabilities, and products that are
“secure by design” will continue to suffer vulnerabilities; however, a large
set of vulnerabilities are due to a relatively small subset of root causes

-_Secure by Design: Principles and Approaches to Secure By Design Software, CISA, 2023_

In this document two definitions now exist that you can hang your hat on as a product designer, or software engineer.

> #### Secure by design
> "Secure by design" means that technology products are built in a way
that reasonably protects against malicious cyber actors successfully
gaining access to devices, data, and connected infrastructure Software
manufacturers should perform a risk assessment to identify and enumerate
prevalent cyber threats to critical systems, and then include protections in
product blueprints that account for the evolving cyber threat landscape.

> #### Secure by default
> “Secure by default” means products are resilient against prevalent
exploitation techniques out of the box without added charge These
products protect against the most prevalent threats and vulnerabilities
without end-users having to take additional steps to secure them Secure
by default products are designed to make customers acutely aware that
when they deviate from safe defaults, they are increasing the likelihood
of compromise unless they implement additional compensatory controls
Secure by default is a form of secure by design

>Security should not be a luxury option, but
should be considered a right customers receive
without negotiating or paying more.

Honestly, there are so many good reasons to read this paper, just do it.

Summarizing for you though, they do a great job of boiling this down to three core principles that any business owner can apply
to their company.

1. Take ownership of customer security outcomes
2. Embrace radical transparency and accountability
3. Build organizational structure and leadership to achieve these goals

For product designers and engineers we go deeper:

- Memory safe language use
- Lean on hardware that can use fine-grained memory protection
- Acquire and maintain secure software components (yes, this means libraries and middleware)
- Lean on web frameworks that properly escape inputs
- Use parameterized database queries to avoid injection flaws
- Use static and dynamic application security testing tools to assist in error detection
- Code review should be a thing you do (i.e. QA)
- Provide an SBoM
- Establish Vulnerability Disclosure programs
- Include root cause or CWE references in CVE reports
- Design infrastructure such that the compromise of a single security control does not result in total system compromise.
- Meet a baseline of Cybersecurity Performance Goals, which are too numerous to mention in this article, [use this link as reference instead](https://www.cisa.gov/cross-sector-cybersecurity-performance-goals).

# At what cost?
Yes, that's right. But if you properly consider history, every time we have a 'black swan' event your customers governments
are more likely to react with legislation. If you simply build like this today, you amortize that cost over the course of years, not months.

Your customers and investors probably won't notice immediately, but when your competitors jack their prices up, you'll be smugly pointing to all the good work you did
over the past few years and reaping the churn.

History shows us that without proactive measures from within, industries often face stringent external regulations. By adopting CISA’s 2023 recommendations now, technology companies can not only avert crises but also pave the way for a safer digital future. It’s not just about avoiding penalties—it’s about leading the charge towards a more secure world. What steps will you take to ensure your products are secure by design?

Final thought, consider [how much government regulation costs other industries](https://www.theregreview.org/2024/02/28/hoguet-estimating-the-impact-of-regulation-on-business/)
and start factoring it into your strategic thinking, today. Because the warning shots have been fired.

*- Complete aside: _In the authors opinion, this is why, time and time again, 'no code' solutions fail to live up to expectations (because they produce
  an unmaintainable mess that defies to be safely modified) and, why the armies of new wave AI-only 'programmers'
  aren't taking all the jobs in IT (because programming isn't the only skill we're hiring for here)._

# References

- https://www.abc.net.au/news/2017-05-14/ransomware-cyberattack-threat-lingers-as-people-return-to-work/8525554
- https://www.wired.com/2002/01/find-the-cost-of-virus-freedom/
- Code-red: case study on the spread and victims of an internet worm, D. Moore, C. Shannon, K. Claffy, https://dl.acm.org/doi/10.1145/637201.637244
- The Internet Worm Program: An Analysis, Eugene H. Spafford, 1988 https://spaf.cerias.purdue.edu/tech-reps/823.pdf
- https://www.theregister.com/2024/08/14/august_patch_tuesday_ipv6/
- https://www.cisa.gov/resources-tools/resources/secure-by-design
- https://www.sec.gov/newsroom/press-releases/2023-139

