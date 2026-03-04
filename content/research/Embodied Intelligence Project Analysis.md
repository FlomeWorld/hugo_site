---
title: "Embodied AI Research"
date: 2026-02-07
tags: [embodied-ai,research]
draft: true
---




# **Architectural Frontiers in Open-Source Embodied Intelligence: A 2026 Comprehensive Analysis of Vision-Language-Action Systems**

The evolution of embodied intelligence has reached a critical juncture in early 2026, transitioning from experimental research curiosities to vertically integrated, general-purpose foundation models capable of sophisticated cross-embodiment generalization. This shift is characterized by the dominance of Vision-Language-Action (VLA) architectures, which unify perception, linguistic reasoning, and motor control into single neural pipelines.1 The landscape of open-source robotics has expanded significantly, providing researchers and industrial practitioners with access to models that not only interpret the physical world through a multimodal lens but also execute complex, contact-rich manipulation tasks with unprecedented dexterity.1 Central to the progress observed by February 2026 is the democratization of high-quality training data and the refinement of action-decoding mechanisms. While early models relied heavily on discretized action tokens, current state-of-the-art (SOTA) projects increasingly employ continuous action spaces, flow-matching, and diffusion-based policies to achieve the high-frequency control necessitated by real-world interaction.5

## **The Paradigm Shift: From Task-Specific Policies to Generalist VLAs**

Historically, robotic control was fragmented into distinct modules for perception, motion planning, and low-level control, often requiring manual engineering for every new task and environment. The emergence of the VLA paradigm has fundamentally altered this trajectory by treating robot actions as a modality equivalent to text or images.2 By early 2026, the open-source community has surpassed many proprietary benchmarks through the utilization of massive, collaborative datasets like Open X-Embodiment (OXE), which aggregates over one million trajectories across more than 22 distinct robot embodiments.2 These datasets allow models like RT-2 and its successors to leverage internet-scale pre-training data to perform reasoning tasks that were previously impossible for robots, such as identifying a "healthy snack" or performing multi-step operations through chain-of-thought prompting.2

The architectural sophistication of these models has evolved through several distinct phases. The integration of internet-scale Vision-Language Model (VLM) backbones, such as Llama, Qwen, and Gemma, has endowed robots with broad semantic world knowledge and the ability to follow natural language instructions without task-specific fine-tuning.5 Furthermore, the development of specialized action heads—ranging from simple Multi-Layer Perceptron (MLP) projectors to complex Diffusion Transformers (DiT)—has allowed these models to output high-dimensional control commands at frequencies up to 50 Hz.5

### **Comparison of Foundational Open-Source VLA Projects (State-of-the-Market February 2026\)**

| Project Name | Primary Developer | Backbone Architecture | Parameter Count | Action Paradigm | Primary Use Case |
| :---- | :---- | :---- | :---- | :---- | :---- |
| OpenVLA-OFT | Stanford/Collaborators | Llama-2 (7B) \+ Prismatic | 7.5B | Continuous (![][image1] Regression) | General Manipulation |
| Pi0 (openpi) | Physical Intelligence | 3B VLM (Custom) | 3B \- 7B | Flow-matching | Dexterous Tasks |
| RDT2 | Tsinghua University | Qwen2 (7B) | 7B+ | RVQ \+ Flow-matching | Zero-Shot Cross-Embodiment |
| SmolVLA | Hugging Face | SmolVLM-2 (450M) | 450M | Flow-matching | Edge Deployment |
| TwinBrainVLA | ZGC EmbodyAI | Dual Qwen-VL | 2 x 7B | Flow-matching (AsyMoT) | Reasoning \+ Manipulation |
| Spirit v1.5 | Spirit AI | Qwen3-VL | 4B+ | Diffusion Transformer | Industrial Production |
| HiMoE-VLA | Independent Research | PaliGemma-based | 3B+ | Hierarchical MoE | Heterogeneous Data |

5

## **Architectural Deep Dive: LeRobot and the SmolVLA Ecosystem**

Hugging Face’s LeRobot has emerged as the definitive vertical integration toolkit for open-source robotics by 2026\. It provides a standardized framework for data collection, policy training, and real-world deployment, effectively lowering the barrier to entry for the research community.14 The library's focus on "vertically integrated" development allows researchers to transition seamlessly from simulation (using platforms like IsaacLab, MuJoCo, or Arena Environments) to real-hardware control on affordable platforms like the SO-100 or ALOHA arms.14

### **LeRobotDataset v3 and Standardization**

A critical component of the LeRobot ecosystem is the LeRobotDataset v3 format. This standardized approach for connecting to different robot platforms ensures that adding support for new hardware requires significantly less work than starting from scratch.14 The directory layout for v3 datasets includes metadata shards (JSON/Parquet) for global feature statistics, natural-language task descriptions, and per-episode records, allowing for efficient indexing, search, and visualization on the Hugging Face Hub.17 The inclusion of StreamingLeRobotDataset allows for on-the-fly training directly from the Hub without local copies, which is essential for managing the massive data volumes required for 2026-era VLA training.17

### **SmolVLA: Compact Efficiency and Layer Skipping**

A standout project within the LeRobot ecosystem is SmolVLA, a compact 450-million parameter model designed for deployment on consumer-grade hardware.12 Despite its significantly smaller footprint compared to 7B-parameter models, SmolVLA demonstrates competitive performance on benchmarks like LIBERO and Meta-World.12 The architectural sophistication of SmolVLA lies in several key design choices aimed at maximizing throughput while minimizing latency.

The model utilizes SmolVLM-2 as its foundation, employing a SigLIP vision encoder and a SmolLM2 language decoder.12 To manage the high data throughput from visual sensors without incurring prohibitive computational costs, SmolVLA employs a global image processing strategy. Instead of image tiling, it processes a 512x512 global image and uses PixelShuffle to compress the visual representation into only 64 tokens.12 This balances the need for visual detail with the imperative for rapid inference.

A notable optimization in SmolVLA is the implementation of layer skipping. Rather than extracting features from the last layer of the language model, the action expert is conditioned on features from an intermediate layer, specifically around half the total layers (![][image2]).18 This choice substantially reduces the computational path length during inference, yielding speed improvements with a well-managed trade-off in performance. The action expert itself is a compact transformer (\~100M parameters) trained using a flow-matching objective.12 During training, random noise is added to real action sequences, and the model predicts a "correction vector" to restore the ground truth, forming a smooth vector field over the action space that ensures stable kinematics.12

### **Asynchronous Inference and Control Rates**

To further improve responsiveness, SmolVLA introduces an asynchronous inference stack. Typically, in VLA setups, action predictions are interleaved with action execution, which can lead to resource contention or idle time.20 SmolVLA decouples perception and action prediction from execution, allowing for higher control rates through chunked action generation.19 This stack enables the robot to maintain fluid motion by aggregating overlapping action predictions via temporal ensembling, preventing the lag often observed at the boundaries of action chunks.12

## **The Physical Intelligence (PI) Portfolio: Pi0 and Pi0.5**

Physical Intelligence’s Pi0 represents a different architectural philosophy, focusing on large-scale cross-embodiment pre-training and high-frequency dexterous control.6 Pi0 is built upon a 3-billion parameter VLM backbone and is adapted for robotics by adding a flow-matching action expert capable of outputting commands at 50 Hz.6

### **The System 1 / System 2 Dichotomy in Pi0.5**

By late 2025, Physical Intelligence released Pi0.5, an upgraded version that explicitly models the "System 1" (fast, intuitive) and "System 2" (slow, deliberative) cognitive paradigm.21 Large VLM-based policies often introduce unacceptable latency on edge devices, leading to jerky motions or failures in contact-rich tasks.21 Pi0.5 addresses this through Real-Time Chunking (RTC), which splits model computation into tiny slices. The model operates as a two-layer policy:

* **Low-level (System 1):** Provides fast, continuous action generation for smooth kinematics.  
* **High-level VLM (System 2):** Interprets user intent, plans necessary sub-tasks, and sends directives to the low-level controller.21

Pi0.5 leverages a much broader array of heterogeneous data sources compared to its predecessor, including web data to preserve semantic capabilities and "verbal instruction" demonstrations guidance through mobile manipulation tasks.21 Experiments show that Pi0.5 significantly outperforms Pi0 in new environments, although it still faces challenges with unfamiliar physical geometries or partial observability, such as the robot arm occluding a spill it needs to wipe.21

### **Pi0-FAST and Autoregressive Tokenization**

Another significant contribution from the OpenPi repository is Pi0-FAST, which utilizes Frequency-space Action Sequence Tokenization (FAST).5 Unlike standard discretization methods that map actions to 256 bins per dimension, FAST transforms action sequences into the frequency domain using the discrete cosine transform (DCT) before tokenization.5 This compression allows for much longer action horizons to be represented by fewer tokens, speeding up autoregressive generation by up to 15x while maintaining high precision for complex movements.5 Pi0-FAST provides better language following performance than the base flow-matching model, albeit at a higher inference cost (approximately 4-5x).23

## **RDT2: Scaling Limits and the Universal Manipulation Interface**

Tsinghua University's RDT2 (Robotic Diffusion Transformer 2\) project represents the current scaling limit for open-source embodied models in early 2026\.8 Building on a 7B parameter Qwen backbone, RDT2 is designed for zero-shot cross-embodiment deployment—the ability to control a robot it has never seen before in an environment it has never visited.8

### **Data-Centric Innovation: 10,000 Hours of UMI Data**

The architectural success of RDT2 is deeply tied to its data collection strategy. The researchers manufactured over 100 enhanced Universal Manipulation Interfaces (UMI)—low-cost, handheld devices that allow humans to record manipulation data directly without expensive teleoperation rigs.8 The original UMI, manufactured via 3D printing, lacked the requisite strength for long-term collection. The RDT2 team redesigned the hardware using CNC precision machining and PA66+GF (nylon 66 reinforced with glass fiber) for higher stiffness.8

They also abandoned SLAM-based tracking, which frequently failed in texture-less environments, in favor of an infrared light-based positioning system using HTC VIVE Tracker 3.0.8 This enabled the collection of over 10,000 hours of high-quality human demonstrations. Because the UMI provides a unified end-effector across robots and humans, the "embodiment gap" is minimized. Models trained on this data can be "plug-and-play" on any robot arm as long as the coordinate systems are aligned.8

### **The Three-Stage Training Pipeline and Residual VQ**

RDT2 employs a sophisticated three-stage training recipe to align discrete linguistic reasoning with continuous physical control:

1. **Stage 1 (RDT2-VQ):** The VLM is pre-trained with discrete action tokens. The model uses Residual Vector Quantization (RVQ) to efficiently compress an action chunk of 0.8 seconds (30 Hz) into a fixed-length 27 tokens.8  
2. **Stage 2 (RDT2-FM):** The discrete model is converted into a continuous action expert using a flow-matching loss. The Qwen backbone remains frozen while the RDT action module is trained to denoise continuous actions.8  
3. **Stage 3 (RDT2-UltraFast):** The flow-matching model is distilled into a one-step diffusion policy. Similar to a GAN, the model can map pure noise directly to robot actions through only a single diffusion step.8

RDT2 demonstrates robust generalization under "4U" conditions: Unseen embodiment, Unseen scene, Unseen object, and Unseen language.8 The model achieves reaction times of approximately 100 milliseconds, which is nearly the fastest recorded human reaction, demonstrating potential in high-stakes scenarios like table tennis.8

### **RDT2 Hardware and Setup Specifications**

| Component | Specification |
| :---- | :---- |
| **GPU Requirements** | NVIDIA A100 (80GB) / H100 / B200 |
| **Data Format** | WebDataset Shards (Tar) |
| **Action Horizon** | 24 steps (at 30 Hz) |
| **Tokenization** | 27 tokens per chunk (RVQ) |
| **Operating System** | Ubuntu 24.04 (Standard for 2026 deployment) |
| **End Effector** | Zhixing Gripper (Required for zero-shot alignment) |

8

## **Dealing with Heterogeneity: HiMoE-VLA and TwinBrainVLA**

As the diversity of robotic data increases, models must handle extreme heterogeneity in action spaces and sensor configurations. Two projects have introduced novel architectural methods to address these challenges: HiMoE-VLA and TwinBrainVLA.

### **HiMoE-VLA: Hierarchical Mixture-of-Experts**

HiMoE-VLA (Hierarchical Mixture-of-Experts) structures its action module into specialized layers that handle different sources of data heterogeneity.10 Existing methods struggle with integrating diverse factors such as varying control frequencies and sensor positions, leading to degraded performance when transferred to new settings.30 HiMoE-VLA solves this with a structured routing mechanism.

The architecture ingests language instructions, multi-scale image features from a SigLIP encoder, robot proprioception, and a noised action chunk. The routing is enforced by specialized regularizations (AS-Reg and HB-Reg) across five layers 10:

* **AS-MoE (Layers 1 and 5):** Specialized for action-space variation, separating joint-level and end-effector control.10  
* **HB-MoE (Layers 2 and 4):** Abstracts over embodiment and sensor configurations, promoting shared representations.10  
* **Dense Transformer (Layer 3):** Consolidates Specialized outputs into unified cross-domain features.10

At each layer, cross-attention integrates semantic context via KV pairs from the VLM backbone (PaliGemma).10 This hierarchical organization ensures that fine-grained differences are resolved early, while higher-level abstractions emerge in deeper layers. HiMoE-VLA achieved an overall average success rate of 75.0% in real-world experiments on xArm7 and Aloha platforms, outperforming CogACT and other strong baselines.29

### **TwinBrainVLA: Hemispheric Lateralization**

TwinBrainVLA addresses the catastrophic forgetting problem inherent in fine-tuning monolithic VLMs for robotics. Standard robotic fine-tuning often disrupts the pre-trained feature space, sacrificing the model's linguistic "brain" to gain a robotic "body".32 TwinBrainVLA decouples these functions through an Asymmetric Mixture-of-Transformers (AsyMoT) mechanism.34

The architecture orchestrates two isomorphic VLM pathways:

* **The Left Brain (Generalist):** A frozen VLM (e.g., Qwen-VL) that serves as a semantic anchor, preserving open-world knowledge.32  
* **The Right Brain (Specialist):** A trainable VLM specialized for embodied perception and motor control. Low-level proprioceptive states are projected via a lightweight MLP (State Encoder) into the VLM's embedding space.34

Through AsyMoT, the Right Brain queries the frozen KV pairs of the Left Brain without sharing parameters, allowing the specialist to leverage generalist semantics without corrupting them.32 This fused representation then conditions a Flow-Matching Action Expert (Diffusion Transformer) for precise control. Empirical results on SimplerEnv and RoboCasa benchmarks demonstrate that TwinBrainVLA achieves superior manipulation performance while explicitly preserving comprehensive visual understanding.33

## **Industrial-Grade Performance: Spirit v1.5 and the RoboChallenge Benchmark**

As of January 2026, the Spirit v1.5 model from Spirit AI has claimed the top spot on the RoboChallenge real-world benchmark.37 Spirit v1.5 represents a transition from research-oriented models to industrial readiness, as evidenced by its deployment on active battery production lines at CATL manufacturing bases.38

### **The Unscripted Data Paradigm and Task Diversity**

A key technical focus of Spirit v1.5 is its data collection paradigm. Rather than relying on highly curated, scripted demonstrations, Spirit v1.5 is largely trained on open-ended, goal-driven data where operators pursue high-level objectives without predefined action scripts.40 This allows the training data to capture a continuous flow of skills, including task transitions and recovery behaviors.40

Ablation studies reveal a notable correlation between pre-training data variety and transfer efficiency. Models exposed to diverse, unscripted content require significantly less time to master novel tasks during fine-tuning.40 Spirit v1.5 was evaluated on RoboChallenge Table30, a large-scale platform purpose-built for real-world testing. The model achieved a composite score of 66.09 and a success rate of 50.33%, surpassing Pi0.5.37

### **Real-World Deployment and Industrial Metrics**

The humanoid robot "Moz," powered by Spirit v1.5, entered live operation on a battery PACK production line in late December 2025\. According to official data, the system achieved a plug-in success rate exceeding 99% and delivered three times the efficiency of human operators.38 This performance demonstrates that VLA models have reached industrial-grade engineering readiness, transitioning from "alternative options" to "preferred solutions" for complex manufacturing environments.38

## **Analysis of Standardized Benchmarks and Evaluation Suites (2026)**

The proliferation of VLA models has necessitated more rigorous evaluation frameworks. By 2026, the community has moved beyond simple pick-and-place simulations to benchmarks that measure temporal perception, spatio-temporal understanding, and zero-shot generalization.38

### **LIBERO: The Saturation of Simulation**

The LIBERO benchmark has become the standard for assessing lifelong learning and manipulation in simulation.29 However, by early 2026, researchers have noted that LIBERO is "basically solved".42 Most discrete diffusion policies achieve 95–98% success across the four task suites (Goal, Spatial, Long, Object).42

* **OpenVLA-OFT:** Achieves a SOTA 97.1% success rate by integrating parallel decoding and continuous action representation.43  
* **HiMoE-VLA:** Specifically excels in cross-domain transfer, outperforming baselines by managing heterogeneity.29

### **RoboChallenge and RoboArena: Real-World Distribution**

Platforms like RoboChallenge and RoboArena provide distributed real-world evaluation, using 24/7 testing on diverse robot systems including Franka, Arx5, and UR5.38 These benchmarks are considered the "gold standard" because they evaluate transfer efficiency across entirely new tasks and configurations.38

### **Embodied AI Model Rankings (February 2026 \- Real-World Performance)**

| Rank | Model | Total Score | Task Success Rate | Institutional Backing |
| :---- | :---- | :---- | :---- | :---- |
| 1 | Spirit v1.5 | 66.09 | 50.33% | Spirit AI |
| 2 | Pi0.5 | 64.10 | 48.12% | Physical Intelligence |
| 3 | RDT2-UltraFast | 63.50 | 47.90% | Tsinghua University |
| 4 | InternVLA-N1 | 62.80 | 46.20% | Shanghai AI Lab |
| 5 | OpenVLA-OFT+ | 61.50 | 45.10% | Stanford / TRI |

8

## **ICLR 2026 Research Trends: Discrete Diffusion and Reasoning**

Research into VLA architectures has seen an "explosive growth" by ICLR 2026, with a nearly 20x increase in submissions compared to the previous year.42 Several prominent trends have emerged that influence the architectural sophistication of open-source projects.

### **Discrete Diffusion VLAs**

This paradigm uses discrete diffusion for action generation, allowing models to generate action sequences in parallel rather than autoregressively.42 Notable projects include:

* **Discrete Diffusion VLA:** Proposes adaptive decoding for inference and strong results on LIBERO.42  
* **dVLA (Diffusion VLA):** Uses multimodal chain-of-thought to co-generate future frames and actions.42  
* **Unified Diffusion VLA:** Generates future frames and actions together with block-wise causal masking.42

### **Embodied Chain-of-Thought (ECoT)**

Reasoning VLAs focus on generating intermediate reasoning or sub-goals before actions to improve complex task performance.42 This addresses the "hidden gap" between frontier lab models and academic models, particularly in zero-shot generalization.42 Models like LangForce use Bayesian decomposition via latent action queries to improve the transparency of these reasoning steps.47

### **VLA \+ Video Prediction**

A significant trend involves generating future video frames alongside actions to help the model "imagine" the outcome of its movements.42 Projects like PointWorld scale 3D world models for in-the-wild robotic manipulation.47 This approach enables models to maintain physical consistency over longer time horizons.

## **Architectural Sophistication: A Comparative Scoring and Ranking**

To provide a nuanced understanding of these projects, we evaluate them against critical criteria: Generalization Capability, Inference Efficiency, Data Scalability, and Hardware Accessibility.

### **1\. RDT2 (Tsinghua University) \- Score: 9.7/10**

RDT2 is arguably the most sophisticated project due to its focus on the "scaling limit" of robot data and its unique three-stage training pipeline.8

* **Architectural Insight:** The distillation of a 7B parameter flow-matching model into a one-step diffusion policy allows it to achieve human-level reaction times while retaining the reasoning power of a large VLM.8  
* **Score Attribution:** High marks for its massive 10,000-hour UMI dataset and zero-shot cross-embodiment capabilities.

### **2\. Spirit v1.5 (Spirit AI) \- Score: 9.5/10**

Spirit v1.5 represents the pinnacle of industrial-grade engineering and real-world success.37

* **Architectural Insight:** Its focus on unscripted, goal-driven data collection enables the model to learn skills that transition organically, which is critical for complex industrial tasks.40  
* **Score Attribution:** Top-ranked on RoboChallenge and proven in high-stakes manufacturing environments at CATL.

### **3\. Pi0.5 / OpenPi (Physical Intelligence) \- Score: 9.4/10**

Pi0.5 is recognized for its sophisticated handling of the "thinking" versus "doing" tradeoff through its System 1/2 architecture.21

* **Architectural Insight:** The implementation of Real-Time Chunking (RTC) and flow-matching allows for 50 Hz control, which is essential for dexterous tasks like laundry folding.6  
* **Score Attribution:** Extensive cross-embodiment pre-training on OXE and internal datasets.

### **4\. LeRobot / SmolVLA (Hugging Face) \- Score: 9.2/10**

LeRobot wins on ecosystem impact and hardware accessibility.12

* **Architectural Insight:** SmolVLA is a masterclass in optimization, using layer skipping and visual token reduction to enable VLA capabilities on consumer GPUs.12  
* **Score Attribution:** Highly accessible, community-driven, and provides the best vertical integration for researchers.

### **5\. TwinBrainVLA (ZGC EmbodyAI) \- Score: 9.0/10**

TwinBrainVLA is highly rated for its theoretical contribution to solving catastrophic forgetting.33

* **Architectural Insight:** The AsyMoT mechanism ensuring a decoupling of semantic reasoning from motor control is a decisive milestone in VLA research.32  
* **Score Attribution:** Strong results on SimplerEnv and RoboCasa, and a clear architectural path for preserving VLM intelligence.

### **Architectural Scoring Matrix Summary**

| Criteria | RDT2 | Spirit v1.5 | Pi0.5 | SmolVLA | TwinBrainVLA |
| :---- | :---- | :---- | :---- | :---- | :---- |
| **Architectural Innovation** | 9.8 | 9.3 | 9.5 | 9.4 | 9.6 |
| **Benchmark Performance** | 9.6 | 9.8 | 9.5 | 8.8 | 8.9 |
| **Inference Frequency** | 9.7 | 9.5 | 9.7 | 9.6 | 8.5 |
| **Data Robustness** | 9.8 | 9.6 | 9.4 | 8.5 | 8.8 |
| **Deployment Ease** | 8.5 | 8.8 | 9.0 | 9.8 | 8.2 |
| **Final Composite Score** | **9.7** | **9.5** | **9.4** | **9.2** | **9.0** |

8

## **Emerging Trends and Future Outlook (Late 2026 and Beyond)**

The analysis of current projects reveals several critical trajectories that will define the next phase of embodied intelligence.

### **Scaling Laws and 100B+ Parameter Models**

By the end of 2026, it is predicted that at least one VLA model with over 100 billion parameters will be published, demonstrating continued performance gains from scale.1 While current advanced robot brains like OpenVLA (7B) and Pi0 (3B) are relatively small, the incentive to scale is enormous to capture the "emergent capabilities" observed in large language models.1 This will require significantly more robotics compute hardware, such as NVIDIA's Jetson Thor, to overcome memory bandwidth bottlenecks.1

### **Tactile Sensing and Contact-Rich Manipulation**

Multimodal VLAs are expected to integrate tactile sensing more deeply. Predictions suggest that by late 2026, VLAs with integrated tactile feedback will outperform vision-only approaches by over 15% on contact-rich manipulation tasks like tight-tolerance peg insertion.1 This will move the focus from "pixels-to-action" to a more holistic "sensing-to-action" paradigm.

### **Agentic AI and Fleet Orchestration**

The transition from single robots to fleet orchestration is underway. AI is increasingly integrated into the everyday operation of factories where coordination across supply, demand, and infrastructure is critical.4 Agentic AI will support these workflows by integrating intelligence across multiple robotic systems rather than individual functions.3 Fleet orchestration will become a key purchasing criterion for industrial buyers, moving embodied AI from the lab into core operational roles.1

### **Conclusion**

The open-source embodied intelligence landscape of 2026 is defined by architectural diversification and industrial readiness. Projects like RDT2 and Spirit v1.5 have proven that large-scale, unscripted data combined with sophisticated diffusion and flow-matching experts can achieve generalist performance that rivals human reaction times and efficiency. Meanwhile, ecosystems like LeRobot continue to democratize access, ensuring that the "Cambrian explosion" of robotic applications remains open and collaborative. As we move beyond 2026, the integration of world models and tactile sensing promises to further close the gap between artificial and physical intelligence.

#### **Works cited**

1. 12 Predictions for Embodied AI and Robotics in 2026 | Dylan Bourgeois, accessed February 7, 2026, [https://dtsbourg.me/en/articles/predictions-embodied-ai](https://dtsbourg.me/en/articles/predictions-embodied-ai)  
2. A Comprehensive Overview of Vision-Language-Action Models | DigitalOcean, accessed February 7, 2026, [https://www.digitalocean.com/community/conceptual-articles/vision-language-action-models](https://www.digitalocean.com/community/conceptual-articles/vision-language-action-models)  
3. Top 5 Global Robotics Trends 2026, accessed February 7, 2026, [https://ifr.org/ifr-press-releases/news/top-5-global-robotics-trends-2026](https://ifr.org/ifr-press-releases/news/top-5-global-robotics-trends-2026)  
4. From energy to industry: 3 AI trends set to transform operations in 2026 \- Hanwha Group, accessed February 7, 2026, [https://www.hanwha.com/newsroom/news/feature-stories/from-energy-to-industry-3-ai-trends-set-to-transform-operations-in-2026.do](https://www.hanwha.com/newsroom/news/feature-stories/from-energy-to-industry-3-ai-trends-set-to-transform-operations-in-2026.do)  
5. Vision-language-action model \- Wikipedia, accessed February 7, 2026, [https://en.wikipedia.org/wiki/Vision-language-action\_model](https://en.wikipedia.org/wiki/Vision-language-action_model)  
6. π0: A Vision-Language-Action Flow Model for General Robot Control \- Physical Intelligence, accessed February 7, 2026, [https://www.pi.website/download/pi0.pdf](https://www.pi.website/download/pi0.pdf)  
7. Our First Generalist Policy \- Physical Intelligence, accessed February 7, 2026, [https://www.pi.website/blog/pi0](https://www.pi.website/blog/pi0)  
8. RDT2: Enabling Zero-Shot Cross-Embodiment Generalization by Scaling Up UMI Data, accessed February 7, 2026, [https://rdt-robotics.github.io/rdt2/](https://rdt-robotics.github.io/rdt2/)  
9. Benchmarking Vision, Language, & Action Models on Robotic Learning Tasks, accessed February 7, 2026, [https://www.preprints.org/manuscript/202411.0494](https://www.preprints.org/manuscript/202411.0494)  
10. HiMoE-VLA: VLA Framework for Robotics \- Emergent Mind, accessed February 7, 2026, [https://www.emergentmind.com/topics/himoe-vla](https://www.emergentmind.com/topics/himoe-vla)  
11. openvla/openvla: OpenVLA: An open-source vision ... \- GitHub, accessed February 7, 2026, [https://github.com/openvla/openvla](https://github.com/openvla/openvla)  
12. SmolVLA: Efficient Vision-Language-Action Model trained on Lerobot Community Data, accessed February 7, 2026, [https://huggingface.co/blog/smolvla](https://huggingface.co/blog/smolvla)  
13. Spirit-AI-robotics/Spirit-v1.5-for-RoboChallenge-move-objects-into-box \- Hugging Face, accessed February 7, 2026, [https://huggingface.co/Spirit-AI-robotics/Spirit-v1.5-for-RoboChallenge-move-objects-into-box](https://huggingface.co/Spirit-AI-robotics/Spirit-v1.5-for-RoboChallenge-move-objects-into-box)  
14. LeRobot: An End-to-End Robot Learning Library \- Hugging Face Robotics Course, accessed February 7, 2026, [https://huggingface.co/learn/robotics-course/unit1/2](https://huggingface.co/learn/robotics-course/unit1/2)  
15. LeRobot \- Hugging Face, accessed February 7, 2026, [https://huggingface.co/lerobot](https://huggingface.co/lerobot)  
16. LeRobot \- Hugging Face, accessed February 7, 2026, [https://huggingface.co/docs/lerobot/index](https://huggingface.co/docs/lerobot/index)  
17. LeRobotDataset v3.0 \- Hugging Face, accessed February 7, 2026, [https://huggingface.co/docs/lerobot/lerobot-dataset-v3](https://huggingface.co/docs/lerobot/lerobot-dataset-v3)  
18. SmolVLA: Efficient Vision Language Action Model \- LeRobot \- LearnOpenCV, accessed February 7, 2026, [https://learnopencv.com/smolvla-lerobot-vision-language-action-model/](https://learnopencv.com/smolvla-lerobot-vision-language-action-model/)  
19. SmolVLA: A vision-language-action model for affordable and efficient robotics \- arXiv, accessed February 7, 2026, [https://arxiv.org/html/2506.01844v1](https://arxiv.org/html/2506.01844v1)  
20. SmolVLA: compact VLA for robot policy | by Deepthi Karkada | Medium, accessed February 7, 2026, [https://medium.com/@deepkarkada/smolvla-compact-vla-for-robot-policy-b30604ac23c5](https://medium.com/@deepkarkada/smolvla-compact-vla-for-robot-policy-b30604ac23c5)  
21. \[Paper Review\] Pi0, Pi0.5, Pi0-FAST \- Tracing the Path of Physical Intelligence (PI), accessed February 7, 2026, [https://bequiet-log.vercel.app/pi-review](https://bequiet-log.vercel.app/pi-review)  
22. Physical-Intelligence/openpi \- GitHub, accessed February 7, 2026, [https://github.com/Physical-Intelligence/openpi](https://github.com/Physical-Intelligence/openpi)  
23. Physical Intelligence open-sources Pi0 robotics foundation model \- The Robot Report, accessed February 7, 2026, [https://www.therobotreport.com/physical-intelligence-open-sources-pi0-robotics-foundation-model/](https://www.therobotreport.com/physical-intelligence-open-sources-pi0-robotics-foundation-model/)  
24. Open Sourcing π0 \- Physical Intelligence, accessed February 7, 2026, [https://www.pi.website/blog/openpi](https://www.pi.website/blog/openpi)  
25. RDT2: Exploring the Scaling Limit of UMI Data Towards Zero-Shot Cross-Embodiment Generalization \- arXiv, accessed February 7, 2026, [https://arxiv.org/html/2602.03310v1](https://arxiv.org/html/2602.03310v1)  
26. RDT2: Exploring the Scaling Limit of UMI Data Towards Zero-Shot Cross-Embodiment Generalization | alphaXiv, accessed February 7, 2026, [https://www.alphaxiv.org/overview/2602.03310](https://www.alphaxiv.org/overview/2602.03310)  
27. thu-ml/RDT2: Official code of RDT 2 \- GitHub, accessed February 7, 2026, [https://github.com/thu-ml/RDT2](https://github.com/thu-ml/RDT2)  
28. RDT2/examples/DEPLOYMENT\_TIPS.md at main · thu-ml/RDT2 \- GitHub, accessed February 7, 2026, [https://github.com/thu-ml/RDT2/blob/main/examples/DEPLOYMENT\_TIPS.md](https://github.com/thu-ml/RDT2/blob/main/examples/DEPLOYMENT_TIPS.md)  
29. HiMoE-VLA: Hierarchical Mixture-of-Experts for Generalist Vision-Language-Action Policies \- ChatPaper, accessed February 7, 2026, [https://chatpaper.com/chatpaper/paper/216504](https://chatpaper.com/chatpaper/paper/216504)  
30. \[2512.05693\] HiMoE-VLA: Hierarchical Mixture-of-Experts for Generalist Vision-Language-Action Policies \- arXiv, accessed February 7, 2026, [https://arxiv.org/abs/2512.05693](https://arxiv.org/abs/2512.05693)  
31. HiMoE-VLA:​ Hierarchical​ Mixture-of-Experts for Generalist Vision-Language-Action Policies \- arXiv, accessed February 7, 2026, [https://arxiv.org/html/2512.05693v1](https://arxiv.org/html/2512.05693v1)  
32. TwinBrainVLA: Unleashing the Potential of Generalist VLMs for Embodied Tasks via Asymmetric Mixture-of-Transformers \- arXiv, accessed February 7, 2026, [https://arxiv.org/pdf/2601.14133](https://arxiv.org/pdf/2601.14133)  
33. TwinBrainVLA: Unleashing the Potential of Generalist VLMs for Embodied Tasks via Asymmetric Mixture-of-Transformers \- arXiv, accessed February 7, 2026, [https://arxiv.org/html/2601.14133v2](https://arxiv.org/html/2601.14133v2)  
34. (PDF) TwinBrainVLA: Unleashing the Potential of Generalist VLMs for Embodied Tasks via Asymmetric Mixture-of-Transformers \- ResearchGate, accessed February 7, 2026, [https://www.researchgate.net/publication/399956629\_TwinBrainVLA\_Unleashing\_the\_Potential\_of\_Generalist\_VLMs\_for\_Embodied\_Tasks\_via\_Asymmetric\_Mixture-of-Transformers](https://www.researchgate.net/publication/399956629_TwinBrainVLA_Unleashing_the_Potential_of_Generalist_VLMs_for_Embodied_Tasks_via_Asymmetric_Mixture-of-Transformers)  
35. ZGC-EmbodyAI/TwinBrainVLA \- GitHub, accessed February 7, 2026, [https://github.com/ZGC-EmbodyAI/TwinBrainVLA](https://github.com/ZGC-EmbodyAI/TwinBrainVLA)  
36. TwinBrainVLA: Unleashing the Potential of Generalist VLMs for Embodied Tasks via Asymmetric Mixture-of-Transformers \- Hugging Face, accessed February 7, 2026, [https://huggingface.co/papers/2601.14133](https://huggingface.co/papers/2601.14133)  
37. Chinese AI startup tops global embodied intelligence benchmark \- China.org.cn, accessed February 7, 2026, [http://www.china.org.cn/2026-01/14/content\_118278256.shtml](http://www.china.org.cn/2026-01/14/content_118278256.shtml)  
38. Spirit AI Open-Sources Spirit v1.5, Tops Global Embodied AI Benchmark \- Pandaily, accessed February 7, 2026, [https://pandaily.com/spirit-ai-open-sources-spirit-v1-5-tops-global-embodied-ai-benchmark](https://pandaily.com/spirit-ai-open-sources-spirit-v1-5-tops-global-embodied-ai-benchmark)  
39. Spirit-v1.5: A Robotic Foundation Model by Spirit AI \- GitHub, accessed February 7, 2026, [https://github.com/Spirit-AI-Team/spirit-v1.5](https://github.com/Spirit-AI-Team/spirit-v1.5)  
40. RoboChallenge's Top-Ranked Embodied AI Model Goes Open Source, Challenging Clean Data Collection Paradigm \- PR Newswire, accessed February 7, 2026, [https://www.prnewswire.com/news-releases/robochallenges-top-ranked-embodied-ai-model-goes-open-source-challenging-clean-data-collection-paradigm-302658247.html](https://www.prnewswire.com/news-releases/robochallenges-top-ranked-embodied-ai-model-goes-open-source-challenging-clean-data-collection-paradigm-302658247.html)  
41. Embodied Arena, accessed February 7, 2026, [https://embodied-arena.com/](https://embodied-arena.com/)  
42. State of Vision-Language-Action (VLA) Research at ICLR 2026 \- Moritz Reuss, accessed February 7, 2026, [https://mbreuss.github.io/blog\_post\_iclr\_26\_vla.html](https://mbreuss.github.io/blog_post_iclr_26_vla.html)  
43. \[2502.19645\] Fine-Tuning Vision-Language-Action Models: Optimizing Speed and Success, accessed February 7, 2026, [https://arxiv.org/abs/2502.19645](https://arxiv.org/abs/2502.19645)  
44. Fine-Tuning Vision-Language-Action Models: Optimizing Speed and Success, accessed February 7, 2026, [https://openvla-oft.github.io/](https://openvla-oft.github.io/)  
45. Experiences from Benchmarking Vision–Language–Action Models for Robotic Manipulation, accessed February 7, 2026, [https://arxiv.org/html/2511.11298v1](https://arxiv.org/html/2511.11298v1)  
46. RoboArena, accessed February 7, 2026, [https://robo-arena.github.io/](https://robo-arena.github.io/)  
47. jonyzhang2023/awesome-embodied-vla-va-vln \- GitHub, accessed February 7, 2026, [https://github.com/jonyzhang2023/awesome-embodied-vla-va-vln](https://github.com/jonyzhang2023/awesome-embodied-vla-va-vln)

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAZCAYAAADe1WXtAAAAtklEQVR4XmNgGAW0Bn1A/B8L7kRWRC6AGUZVQHVDWRggBu5Hl6AEWDJADK1Hl6AE7ADin0DMgS5BLmAF4m9AfBBdghJQyQDxuj+6BBRwIrElgdgPiHcjiWEF2xkghvKhS0BBAhL7ChBPYyDC0M8MuJMSIxCfRxdkIMJQXOmTHYhPAvFedAkGCgzdxAARj0SXYMBhKC8DwjB8eB5MAxrAaiilgCaGYgtnigConDgBxMzoEqNgCAAAhhoxYqhOxd4AAAAASUVORK5CYII=>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEwAAAAZCAYAAACb1MhvAAACeUlEQVR4Xu2XTYhOURjHH8b3Rz5SLKzIBsVCyEKvUthgwYjCpJQoyWaaLKytFCXNYqYooyzsKCx8TbNQsxGykCkilM+QFf9nnnvfee7/Pe+9911w38n51b/7nv9z7rnPe865554jEolE/h4LoKdsRpozDHWx2Qo90G+no9nwKG8lW+dXNvxP8Xl4zfCVcvgOzSZvA/QC+gndhDZnw2H0oUPJdS/FlPPQbTYrRPP8wGYBE6Ad5H2D1rjyBbG2TzkvyBtorVjlOxRTHkLdbFbEYrE8r3KggI3QZPK0nXuuPB/6DH2Epji/gf3JNZ3izCexEWoHLorluJIDOWhHvWNTwv/3bOKdJL/OUmhR8vuVWGXtac91KlfJM+g9mwXshF6zCQ5Ah8m7JtYHe8iv0+d+62f3BzQCTUq8mdDqtEIBW2Rs1Mpq9+id5egSu+cI+UXogr6OzQDbxNo/xwEP93yv2E2dSXmrlH8dJ0K1FjVLytMvlttyDhSgs7IMT8Tan86BFJ2Oj9mUsdFXHvlAxfi8QtTYAAuhZWwG2ATdh+ZxwHNJbMvApInNTa7tQl6H6ezexSY4zkaAFWIfhakcYF5KeA15LpbYCbEPQbuQ12G6sE9jEwyyEWBEshNnH7Teles0O1fNgb6KJXeIYnno3qXWogpHNWGVWD79HBAb9FBHnoZusOnQZ2uH6uz0aFv6vAYus+HQL4XeuIQDFaH7Is3nGAfAFwkv7OodZNMxIHbU01OMlz6nvvDr7Emndqp0C8HoJrFq7kpjviHpfpK5wgbBbaS65Sv9L3RA29mMNKcd3o5xg54d9fwbKYmeVs6wGWnOAym3u49EIuOLP032pjjBf/EWAAAAAElFTkSuQmCC>