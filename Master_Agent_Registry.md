# Master Agent Registry - Project Aegis

This registry outlines the instantiation of the 200 Coder Bots, categorized by Guild, Role, and Responsibility.

## Guild A: The Architects (Agents 001 - 020)
**Role:** System Core & UI Management
**Source of Truth:** Aegis_Ultimate_Manifest.json (Config/Settings)

*   **Agent 001: The Prime Orchestrator**
    *   **Task:** Manages the Main Loop (Finite State Machine) and high-level logic flow.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Global Settings).

*   **Agent 002: The Librarian**
    *   **Task:** Manages `BaseClass.lua`. Responsible for lazy-loading and parsing JSON data.
    *   **Reference:** Aegis_Ultimate_Manifest.json (I/O Operations).

*   **Agent 003: UI Architect**
    *   **Task:** Handles Rayfield Suite integration and UI component rendering.
    *   **Reference:** Aegis_Ultimate_Manifest.json (UI Configuration).

*   **Agent 004: The Auditor**
    *   **Task:** Compiles all modules into the final Delta-compatible bundle; verifies integrity.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Build Manifest).

*   **Agents 005 - 020: System Stability Engineers**
    *   **Task:** Manage configuration persistence, error logging, and crash recovery routines.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Error Codes & Config Schema).

---

## Guild B: The Navigators (Agents 021 - 055)
**Role:** Physics, Movement & Pathfinding
**Source of Truth:** BSS_Coordinates.json (Spatial Data)

*   **Agent 021: Physics Lead**
    *   **Task:** Manages `Navigator.lua` and core movement logic.
    *   **Reference:** BSS_Coordinates.json (Global Constraints).

*   **Agents 022 - 035: Tween Masters**
    *   **Task:** Calculate dynamic speeds and handle CFrame tweening vs. Humanoid.WalkSpeed logic.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Speed Settings).

*   **Agents 036 - 045: Obstacle Analysts**
    *   **Task:** Create "Safety Zones" and collision avoidance logic (e.g., Mountain Top edges).
    *   **Reference:** BSS_Coordinates.json (Zone Boundaries).

*   **Agents 046 - 055: Pathfinders**
    *   **Task:** specialized navigation for hard-to-reach areas (Star Hall, Dapper Bear's Shop).
    *   **Reference:** BSS_Coordinates.json (Special Locations).

---

## Guild C: The Harvesters (Agents 056 - 100)
**Role:** Collection & Field Mechanics
**Source of Truth:** Aegis_Ultimate_Manifest.json (Collection Rules) & BSS_Coordinates.json (Field Locations)

*   **Agent 056: Harvest Lead**
    *   **Task:** Manages `Collector.lua` and tool interaction logic.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Tool Stats).

*   **Agents 057 - 075: Token Evaluators**
    *   **Task:** Scan Workspace for tokens and compare against the "Priority List".
    *   **Reference:** Aegis_Ultimate_Manifest.json (Priority List - Tab 2).

*   **Agents 076 - 085: Passive Monitors**
    *   **Task:** Monitor passive buffs (Pop Star, Gummy Star) and enforce zone constraints.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Buff Mechanics).

*   **Agents 086 - 100: Field Mechanics Specialists**
    *   **Task:** Automate field deployables: Auto Sprinkler, Auto Dig, Farm Bubbles/Coconuts.
    *   **Reference:** BSS_Coordinates.json (Field Dispenser Locations).

---

## Guild D: The Slayers (Agents 101 - 140)
**Role:** Combat & Mob Management
**Source of Truth:** Aegis_Ultimate_Manifest.json (Mob HP/Stats) & BSS_Coordinates.json (Mob Spawns)

*   **Agent 101: Combat Lead**
    *   **Task:** Manages `Slayer.lua` and target acquisition.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Combat Settings).

*   **Agent 102: Coconut Crab Specialist**
    *   **Task:** Implements circle-strafe logic for Coconut Crab boss.
    *   **Reference:** BSS_Coordinates.json (Coconut Field Arena).

*   **Agent 103: Stump Snail Specialist**
    *   **Task:** Implements AFK-kill logic for Stump Snail.
    *   **Reference:** BSS_Coordinates.json (Stump Field).

*   **Agent 104: Commando Chick Specialist**
    *   **Task:** Implements Tween-evasion logic for Commando Chick.
    *   **Reference:** BSS_Coordinates.json (Commando Chick Location).

*   **Agents 105 - 120: Boss Strategy Optimizers**
    *   **Task:** Handle tactics for other bosses (King Beetle, Tunnel Bear, Stick Bug, etc.).
    *   **Reference:** BSS_Coordinates.json (Boss Lairs).

*   **Agents 121 - 130: Mob Sweepers**
    *   **Task:** Routine clearing of Ladybugs, Rhinos, and Spiders in active fields.
    *   **Reference:** BSS_Coordinates.json (Mob Zones).

*   **Agents 131 - 140: Gear Swappers**
    *   **Task:** Auto-equip masks (Demon/Diamond) based on target boss or pollen type.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Gear Stats).

---

## Guild E: The Strategists (Agents 141 - 180)
**Role:** Quest Logic & Resource Management
**Source of Truth:** Aegis_Ultimate_Manifest.json (Quests) & BSS_Coordinates.json (NPC Locations)

*   **Agent 141: Logic Lead**
    *   **Task:** Manages `QuestBot.lua` and quest chain progression.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Quest Database).

*   **Agents 142 - 170: Bear Analysts (NPC Specific)**
    *   **Task:** Each agent assigned to a specific NPC (Black Bear, Mother Bear, Brown Bear, Science Bear, etc.) to parse requirements.
    *   **Reference:** Aegis_Ultimate_Manifest.json (NPC Quest Lines).

*   **Agents 171 - 180: Resource Managers**
    *   **Task:** Manage inventory, "Convert at %" logic, and Micro-Converter usage.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Inventory Settings).

---

## Guild F: The Hallucination Wardens (Agents 181 - 200)
**Role:** QA, Debugging & Optimization
**Source of Truth:** All Files (Cross-Reference)

*   **Agents 181 - 190: Logic Debaters**
    *   **Task:** Review code generated by other agents; flag logic errors or hallucinations not supported by JSONs.
    *   **Reference:** Aegis_Ultimate_Manifest.json & BSS_Coordinates.json (Validation).

*   **Agents 191 - 200: Delta Optimization Engineers**
    *   **Task:** Optimize code for mobile execution, minimize memory leaks, and ensure Delta executor compatibility.
    *   **Reference:** Aegis_Ultimate_Manifest.json (Performance Constraints).
