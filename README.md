# WSN_Energy_Analysis
Simulation and analysis of energy consumption in Wireless Sensor Networks (WSN) using NS-2. Compares static, half-mobile, and full-mobile node setups with Python-based visualization of energy efficiency.

<h1 align="center">🛰️ WSN Energy Analysis using NS-2</h1>

<p align="center">
  <b>Analyze energy consumption in static and mobile Wireless Sensor Networks (WSN) using NS-2 & Python</b><br>
  <i>By <strong>B NANDIVARDHAN REDDY</strong> </i>
</p>



---

## 📘 Project Summary

This repository contains a reproducible NS-2 simulation and analysis pipeline that compares **energy consumption** of Wireless Sensor Networks under three mobility scenarios:

- **Static** (0% mobile nodes)  
- **Half-Mobile** (50% mobile nodes)  
- **Full-Mobile** (100% mobile nodes)

Energy is logged for each node using NS-2's `EnergyModel` and results are visualized with Python (Matplotlib). The project helps demonstrate how mobility impacts energy drain and network lifetime.

---

# 🧭 Procedure (Step-by-Step)

1. **Setup Environment**
   - Install NS-2, NAM, Python3, and Matplotlib on Ubuntu.  
   - Verify NS-2 installation using `ns -v`.

2. **Prepare Simulation**
   - Place the `wsn_static_vs_mobile.tcl` file and scripts (`run_all.sh`, Python scripts) in the project directory.  
   - Open the terminal and navigate to your project folder:
     ```bash
     cd ~/WSN_Energy_Analysis
     ```

3. **Make Script Executable**
   - Run this once:
     ```bash
     chmod +x run_all.sh
     ```

4. **Run the Simulations**
   - Execute the main script to simulate all three cases:
     ```bash
     ./run_all.sh
     ```
   - This automatically simulates:
     - Static (0.0 mobility)
     - Half-Mobile (0.5 mobility)
     - Full-Mobile (1.0 mobility)

5. **Generate and View Results**
   - All results are saved in the `results/` folder.
   - To plot the comparison graph, run:
     ```bash
     python3 compare_energy.py
     ```
   - The output graph (`energy_comparison.png`) displays **Average Energy vs Time** for all scenarios.

6. **Interpret the Graph**
   - Observe how energy decreases faster in mobile node setups due to frequent route rediscoveries and packet losses.

---

## 📊 Observation

| Scenario | Node Mobility | Energy Drain | Remarks |
|-----------|----------------|--------------|----------|
| **Static (0.0)** | No mobility | 🟢 Lowest | Energy-efficient due to stable links |
| **Half-Mobile (0.5)** | Moderate mobility | 🟡 Medium | Some control packet overhead |
| **Full-Mobile (1.0)** | High mobility | 🔴 Highest | Frequent route changes increase energy usage |

- Static nodes maintain stable routes → less control overhead.  
- Increased mobility leads to more **AODV route discoveries** and higher **transmission energy**.  
- Energy consumption rate rises as node mobility increases.  

---

## 🧠 Conclusion

1. As **node mobility increases**, **energy consumption rises** due to:
   - Frequent topology changes  
   - Route rediscovery and control packet overhead  
   - Additional retransmissions caused by link breakages  

2. **Static WSNs** offer the best energy efficiency and network stability.  
3. **Mobile WSNs** provide better flexibility but consume more energy.  
4. To optimize energy usage in mobile networks:
   - Use **energy-aware routing protocols** (e.g., LEACH, PEGASIS).  
   - Implement **duty-cycling or sleep scheduling**.  
   - Integrate **energy harvesting systems** for long-term deployments.

**Final Result:**  
> Static nodes conserve more energy, while mobility introduces higher consumption — confirming the direct impact of movement on network lifetime.

---

## 📜 License

This project is distributed under the **MIT License**.  
You are free to use, modify, and share this project **with proper credit**.


---

## 👨‍💻 Author

**Name:** B NANDIVARDHAN REDDY  
**GitHub:** [github.com/nandivardhan011](https://github.com/nandivardhan011)  
**LinkedIn:** [linkedin.com/in/](https://www.linkedin.com/in/b-nandivardhan-reddy)  

---



<p align="center">
  ⭐ If you found this project useful, give it a Star on GitHub! ⭐
</p>



