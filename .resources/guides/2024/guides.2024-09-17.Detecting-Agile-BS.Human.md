---
title: Detecting Agile BS
short_title: Detecting Agile BS
description: Guidance for identifying genuine agile software development in DoD projects, including key principles, warning signs, essential tools, and critical evaluation questions.
date: 2024-09-17
weight: 360
ResourceId: Tt8SPr3xJER
ResourceImport: false
ResourceType: guides
slug: detecting-agile-bs
aliases:
- /Guides/Detecting-Agile-BS.html
- /learn/agile-delivery-kit/guides/detecting-agile-bs
- /resources/Tt8SPr3xJER
aliasesArchive:
- /Guides/Detecting-Agile-BS.html
- /learn/agile-delivery-kit/guides/detecting-agile-bs
concepts:
- Tool
categories:
- Product Development
- Engineering Excellence
tags:
- Customer Focus
- Software Development
- Operational Practices
- Product Delivery
ResourceContentOrigin: Human
resourceTypes: guide
layout: guide
image: https://nkdagility.com/wp-content/uploads/2020/12/image-2.png
references:
- title: DIB Guide - Detecting Agile BS
  url: https://media.defense.gov/2019/May/02/2002127286/-1/-1/0/DIBGUIDEDETECTINGAGILEBS.PDF
- title: Defense Innovation Board Ten Commandments of Software
  url: https://media.defense.gov/2018/Apr/22/2001906836/-1/-1/0/DEFENSEINNOVATIONBOARD_TEN_COMMANDMENTS_OF_SOFTWARE_2018.04.20.PDF
- title: Defense Innovation Board Metrics for Software Development
  url: https://media.defense.gov/2018/Jul/10/2001940937/-1/-1/0/DIB_METRICS_FOR_SOFTWARE_DEVELOPMENT_V0.9_2018.07.10.PDF
- title: Defense Innovation Board Do’s and Don’ts for Software
  url: https://media.defense.gov/2018/Oct/09/2002049593/-1/-1/0/DIB_DOS_DONTS_SOFTWARE_2018.10.05.PDF
videos:
- title: stackconf 2021 | The Tyranny of Taylorism and how to spot Agile BS
  embed: https://www.youtube.com/embed/OJ-7YVekG2s
- title: 'stackconf online 2020 | Agile Evolution: An Enterprise transformation that shows that you can too'
  embed: https://www.youtube.com/embed/6D7ZC5Yq8rU
- title: 'Agile Evolution: Live Site Culture & Site Reliability at Azure DevOps'
  embed: https://www.youtube.com/embed/5bgcpPqcGlw
creator: Martin Hinshelwood
card:
  button:
    content: Learn More
  content: Discover more about Detecting Agile BS and how it can help you in your Agile journey!
  title: Detecting Agile BS
Watermarks:
  description: 2025-05-07T12:58:02Z
  short_title: 2025-07-07T16:40:40Z

---
Agile is a buzzword of [software development]({{< ref "/tags/software-development" >}}), and so all DoD software development projects are, almost by default, now declared to be “agile.” The purpose of this document is to provide guidance to DoD program executives and acquisition professionals on how to detect software projects that are really using agile development versus those that are simply waterfall or spiral development in agile clothing (“agile-[scrum]({{< ref "/categories/scrum" >}})-fall”).

![Detecting Agile BS](https://nkdagility.com/wp-content/uploads/2020/12/image-2.png){: .responsiveImage}

## Principles, Values, and Tools

Experts and devotees profess certain key “values” to characterize the culture and approach of
agile development. In its work, the DIB has developed its own guiding maxims that roughly map
to these true agile values:

| Agile value                                                                               | DIB maxim                                                                                             |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Individuals and interactions over processes and tools                                     | “[Competence]({{< ref "/tags/competence" >}}) trumps process”                                         |
| [Working software]({{< ref "/tags/working-software" >}}) over comprehensive documentation | “Minimize time from program launch to deployment of simplest useful functionality”                    |
| Customer collaboration over contract negotiation                                          | “Adopt a DevSecOps culture for software systems”                                                      |
| Responding to change over following a plan                                                | “Software programs should start small, be iterative, and build on success ‒ or be terminated quickly” |

{: .table .table-striped .table-bordered .d-none .d-md-block}

Key flags that a project is not really agile:

- Nobody on the software development team is talking with and observing the users of the software in action; we mean the actual users of the actual code.1 (The Program Executive Office (PEO) does not count as an actual user, nor does the commanding officer, unless she uses the code.)
- Continuous feedback from users to the development team (bug reports, users assessments) is not available. Talking once at the beginning of a program to verify requirements doesn’t count!
- Meeting requirements is treated as more important than getting something useful into the field as quickly as possible.
- Stakeholders (development, test, ops, security, contracting, contractors, end-users, etc.)2 are acting more-or-less autonomously (e.g. ‘it’s not my job.’)
- End users of the software are missing-in-action throughout development; at a minimum, they should be present during Release Planning and User Acceptance Testing.
- DevSecOps culture is lacking if manual processes are tolerated when such processes can and should be automated (e.g. [automated testing]({{< ref "/tags/automated-testing" >}}), [continuous integration]({{< ref "/tags/continuous-integration" >}}), [continuous delivery]({{< ref "/tags/continuous-delivery" >}})).

Some current, common tools in use by teams using agile development (these will change as better tools become available):

- Git, ClearCase, or Subversion – version control system for tracking changes to source code. Git is the de-facto open-source standard for modern software development.
- [Azure Repos]({{< ref "/tags/azure-repos" >}}), BitBucket, [GitHub]({{< ref "/tags/github" >}}) – repository hosting sites. Also provide issues tracking, continuous integration “apps” and other productivity tools. Widely used by the open-source community.
- [Azure Pipelines]({{< ref "/tags/azure-pipelines" >}}), Jenkins, Circle CI, Travis CI – continuous integration service used to build and test BitBucket and GitHub software projects
- Chef, Ansible, or Puppet – software for writing [system configuration]({{< ref "/tags/system-configuration" >}}) “recipes” and streamlining the task of configuring and maintaining a collection of servers
- Docker – a computer program that performs operating-system-level virtualization, also known as “containerization”
- Kubernetes or Docker Swarm – for container orchestration
- [Azure Boards]({{< ref "/tags/azure-boards" >}}), GitHub, Jira, Pivotal Tracker – issues reporting, tracking, and management

Graphical version:

![DIB DevSecOps Technology Stack](https://nkdagility.com/wp-content/uploads/2020/12/image-1-768x428.png){: .responsiveImage}

## Questions to Ask

- How do you test your code? (Wrong answers: “we have a testing organization”, “OT&E is responsible for testing”)
  Advanced version: what tool suite are you using for unit tests, regression testing, functional tests, security scans, and deployment certification?
- How automated are your development, testing, security, and deployment pipelines?
  Advanced version: what tool suite are you using for continuous integration (CI), continuous deployment (CD), regression testing, program documentation; is your infrastructure defined by code?
- Who are your users and how are you interacting with them?
  Advanced version: what mechanisms are you using to get direct feedback from your users? What tool suite are you using for issue reporting and tracking? How do you allocate issues to programming teams? How to you inform users that their issues are being addressed and/or have been resolved?
- What is your (current and future) [cycle time]({{< ref "/tags/cycle-time" >}}) for releases to your users?
  Advanced version: what software platforms to you support? Are you using containers? What configuration management tools do you use?

## Questions for Program Management

- How many programmers are part of the organizations that own the budget and milestones for the program? (Wrong answers: “we don’t know,” “zero,” “it depends on how you define a programmer”)
- What are your management metrics for development and operations; how are they used to inform priorities, detect problems; how often are they accessed and used by [leadership]({{< ref "/categories/leadership" >}})?
- What have you learned in your past three sprint cycles and what did you do about it? (Wrong answers: “what’s a sprint cycle?,” “we are waiting to get approval from management”)
- Who are the users that you deliver value to each sprint cycle? Can we talk to them? (Wrong answers: “we don’t directly deploy our code to users”)

## Questions for Customers and Users

- How do you communicate with the developers? Did they observe your relevant teams working and ask questions that indicated a deep understanding of your needs? When is the last time they sat with you and talked about features you would like to see implemented?
- How do you send in suggestions for new features or report issues or bugs in the code? What type of feedback do you get to your requests/reports? Are you ever asked to try prototypes of new software features and observed using them?
- What is the time it takes for a requested feature to show up in the application?

## Questions for Program Leadership

- Are teams delivering working software to at least some subset of real users every iteration (including the first) and gathering feedback? (alt: every two weeks)
- Is there a product charter that lays out the mission and [strategic goals]({{< ref "/tags/strategic-goals" >}})? Do all members of the team understand both, and are they able to see how their work contributes to both?
- Is feedback from users turned into concrete work items for sprint teams on timelines shorter than one month?
- Are teams empowered to change the requirements based on user feedback?
- Are teams empowered to change their process based on what they learn?
- Is the full ecosystem of your project agile? (Agile programming teams followed by linear, bureaucratic deployment is a failure.)

More information on some of the features of DoD software programs are included in Appendix A [DIB Ten Commandments on Software](https://media.defense.gov/2018/Apr/22/2001906836/-1/-1/0/DEFENSEINNOVATIONBOARD_TEN_COMMANDMENTS_OF_SOFTWARE_2018.04.20.PDF), Appendix B [DIB Metrics for Software Development](https://media.defense.gov/2018/Jul/10/2001940937/-1/-1/0/DIB_METRICS_FOR_SOFTWARE_DEVELOPMENT_V0.9_2018.07.10.PDF),
and Appendix C [DIB Do’s and Don’ts of Software](https://media.defense.gov/2018/Oct/09/2002049593/-1/-1/0/DIB_DOS_DONTS_SOFTWARE_2018.10.05.PDF).
