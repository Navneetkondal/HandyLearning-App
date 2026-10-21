#!/usr/bin/env python3
"""
compile_mobile_design.py
Compiles the enhanced handyLearn Mobile Prototype HTML application.
Integrates:
- All 32 Canonical Domains and 128 Topics with full 14-section architectural blueprints
- All 7 Master Special Reference Sections from SwiftHandbook:
  1. Senior 100 Q&A Bank
  2. 89-Question Technical Exam Bank
  3. Git Masterclass & Lead Puzzles (33 scenarios)
  4. 5 Production Mobile System Design Blueprints
  5. Enterprise Production Defense & Hardening
  6. 16 Staff & Architect Calibration Signals
  7. Career Progression & 0-12+ YoE Rubric
- Dynamic bottom dock navigation with 5 distinct view modes:
  [Domains (32)] [Senior 100] [Exam 89] [Git Puzzles] [Staff & Designs]
- Full dual-theming (Luminous Dark / Clean Light) with WCAG AA compliance
- Dynamic search, filters, modal inspectors, and desktop tree sidecar
"""

import json
import os

with open('/tmp/master_domains.json', 'r', encoding='utf-8') as f:
    domains = json.load(f)

with open('/tmp/special_sections.json', 'r', encoding='utf-8') as f:
    special_sections = json.load(f)

html_template = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>handyLearn Mobile App Design — 32 Domains & Full Master Handbook Banks</title>
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600&family=Inter:wght@300;400;500;600;700;800;900&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap" rel="stylesheet">
  
  <style>
    :root {
      --color-scheme: dark;
      --bg-backdrop: #070a10;
      --bg-app: #0d121c;
      --bg-surface: #141b29;
      --bg-surface-elevated: #1d2538;
      --bg-card: #182233;
      --bg-card-hover: #222d42;
      --bg-chip: #1e283d;
      --bg-code: #0b0f17;
      
      --border-subtle: rgba(255, 255, 255, 0.08);
      --border-medium: rgba(255, 255, 255, 0.16);
      --border-active: #6366f1;
      
      --text-primary: #f8fafc;
      --text-secondary: #94a3b8;
      --text-muted: #64748b;
      
      --brand-primary: #6366f1;
      --brand-primary-light: #818cf8;
      --brand-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #d946ef 100%);
      
      --ios-orange: #f97316;
      --ios-gradient: linear-gradient(135deg, #f97316 0%, #fb923c 100%);
      
      --radius-xs: 6px;
      --radius-sm: 10px;
      --radius-md: 14px;
      --radius-lg: 20px;
      --radius-xl: 28px;
      --radius-full: 9999px;
      
      --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.25);
      --shadow-md: 0 4px 14px rgba(0, 0, 0, 0.35);
      --shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.5);
      --shadow-glow: 0 0 24px rgba(99, 102, 241, 0.28);
      
      --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
      --transition-normal: 250ms cubic-bezier(0.4, 0, 0.2, 1);
      --transition-spring: 350ms cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    [data-theme="light"] {
      --color-scheme: light;
      --bg-backdrop: #e5e9f0;
      --bg-app: #f8fafc;
      --bg-surface: #ffffff;
      --bg-surface-elevated: #f1f5f9;
      --bg-card: #ffffff;
      --bg-card-hover: #f8fafc;
      --bg-chip: #f1f5f9;
      --bg-code: #f1f5f9;
      
      --border-subtle: #e2e8f0;
      --border-medium: #cbd5e1;
      --border-active: #4f46e5;
      
      --text-primary: #0f172a;
      --text-secondary: #475569;
      --text-muted: #94a3b8;
      
      --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06);
      --shadow-md: 0 4px 12px rgba(15, 23, 42, 0.08);
      --shadow-lg: 0 12px 28px rgba(15, 23, 42, 0.12);
      --shadow-glow: 0 0 20px rgba(99, 102, 241, 0.2);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: var(--bg-backdrop);
      color: var(--text-primary);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 24px 16px 60px;
      overflow-x: hidden;
    }

    .showcase-wrapper {
      width: 100%;
      max-width: 1400px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 24px;
    }

    .showcase-header {
      text-align: center;
      max-width: 820px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
    }

    .badge-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 14px;
      background: rgba(99, 102, 241, 0.15);
      border: 1px solid rgba(99, 102, 241, 0.3);
      border-radius: var(--radius-full);
      font-size: 12px;
      font-weight: 700;
      color: var(--brand-primary-light);
      letter-spacing: 0.3px;
    }

    .showcase-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 32px;
      font-weight: 800;
      letter-spacing: -0.8px;
      background: var(--brand-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      line-height: 1.2;
    }

    .showcase-desc {
      font-size: 14.5px;
      line-height: 1.6;
      color: var(--text-secondary);
    }

    .showcase-controls {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-top: 8px;
      flex-wrap: wrap;
      justify-content: center;
    }

    .control-btn {
      padding: 8px 16px;
      border-radius: var(--radius-full);
      background: var(--bg-surface);
      border: 1px solid var(--border-subtle);
      color: var(--text-secondary);
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all var(--transition-fast);
    }

    .control-btn:hover, .control-btn.active {
      background: var(--brand-primary);
      color: #fff;
      border-color: var(--brand-primary);
      box-shadow: var(--shadow-glow);
    }

    /* PROTOTYPE CANVAS LAYOUT */
    .prototype-container {
      display: flex;
      align-items: flex-start;
      justify-content: center;
      gap: 40px;
      width: 100%;
      margin-top: 10px;
    }

    /* IPHONE 16 PRO HARDWARE CHASSIS */
    .device-shell {
      width: 410px;
      height: 860px;
      background: #020408;
      border-radius: 56px;
      padding: 12px;
      box-shadow: 
        0 0 0 4px #2b3345,
        0 0 0 8px #141721,
        0 25px 60px -10px rgba(0, 0, 0, 0.8),
        0 0 40px rgba(99, 102, 241, 0.15);
      position: relative;
      flex-shrink: 0;
      user-select: none;
    }

    .device-screen {
      width: 100%;
      height: 100%;
      background: var(--bg-app);
      border-radius: 46px;
      overflow: hidden;
      position: relative;
      display: flex;
      flex-direction: column;
      box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.06);
    }

    /* HARDWARE DYNAMIC ISLAND */
    .dynamic-island-wrapper {
      position: absolute;
      top: 11px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 100;
      pointer-events: none;
    }

    .dynamic-island {
      width: 120px;
      height: 33px;
      background: #000000;
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.5);
    }

    .camera-lens {
      width: 11px;
      height: 11px;
      border-radius: 50%;
      background: #111422;
      border: 1px solid #1e2538;
    }

    .face-id-sensor {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #0a0c16;
    }

    /* STATUS BAR */
    .status-bar {
      height: 48px;
      padding: 14px 26px 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13.5px;
      font-weight: 700;
      color: var(--text-primary);
      z-index: 90;
      flex-shrink: 0;
    }

    /* APP TOP BAR */
    .app-header {
      padding: 4px 18px 12px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-shrink: 0;
      border-bottom: 1px solid var(--border-subtle);
      background: var(--bg-surface);
    }

    .brand-group {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .app-logo-badge {
      width: 34px;
      height: 34px;
      border-radius: var(--radius-sm);
      background: var(--brand-gradient);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: 900;
      color: #fff;
      box-shadow: var(--shadow-sm);
    }

    .brand-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 17px;
      font-weight: 800;
      letter-spacing: -0.4px;
      color: var(--text-primary);
    }

    .brand-stats-sub {
      font-size: 10.5px;
      font-weight: 700;
      color: var(--brand-primary-light);
      letter-spacing: 0.5px;
      text-transform: uppercase;
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .icon-btn {
      width: 32px;
      height: 32px;
      border-radius: var(--radius-full);
      background: var(--bg-surface-elevated);
      border: 1px solid var(--border-subtle);
      color: var(--text-secondary);
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      font-size: 14px;
      transition: all var(--transition-fast);
    }

    .icon-btn:hover {
      color: var(--text-primary);
      border-color: var(--border-medium);
      background: var(--brand-primary);
    }

    /* APP VIEWPORT CONTAINER */
    .app-viewport {
      flex: 1;
      overflow-y: auto;
      overflow-x: hidden;
      padding: 12px 14px 90px;
      position: relative;
    }

    .app-viewport::-webkit-scrollbar {
      display: none;
    }

    /* SEARCH BAR */
    .mobile-search-bar {
      margin-bottom: 12px;
    }

    .search-input-wrap {
      position: relative;
      width: 100%;
    }

    .search-icon-pre {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 13px;
      color: var(--text-muted);
      pointer-events: none;
    }

    .search-input-box {
      width: 100%;
      padding: 9px 12px 9px 34px;
      border-radius: var(--radius-md);
      background: var(--bg-surface);
      border: 1px solid var(--border-subtle);
      color: var(--text-primary);
      font-size: 12.5px;
      outline: none;
      transition: all var(--transition-fast);
    }

    .search-input-box:focus {
      border-color: var(--brand-primary);
      box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
    }

    .search-count-badge {
      position: absolute;
      right: 10px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 10px;
      font-weight: 700;
      color: var(--text-muted);
      background: var(--bg-surface-elevated);
      padding: 2px 6px;
      border-radius: var(--radius-xs);
    }

    /* HORIZONTAL CHIP PILLS */
    .chips-rail {
      display: flex;
      gap: 6px;
      overflow-x: auto;
      padding-bottom: 8px;
      margin-bottom: 10px;
    }

    .chips-rail::-webkit-scrollbar { display: none; }

    .chip-item {
      padding: 5px 12px;
      border-radius: var(--radius-full);
      background: var(--bg-surface);
      border: 1px solid var(--border-subtle);
      color: var(--text-secondary);
      font-size: 11px;
      font-weight: 700;
      white-space: nowrap;
      cursor: pointer;
      transition: all var(--transition-fast);
      flex-shrink: 0;
    }

    .chip-item.active {
      background: var(--brand-primary);
      color: #fff;
      border-color: var(--brand-primary);
    }

    /* DOMAINS ACCORDION HIERARCHY */
    .domain-accordion {
      background: var(--bg-card);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-md);
      margin-bottom: 10px;
      overflow: hidden;
      transition: all var(--transition-normal);
      box-shadow: var(--shadow-sm);
    }

    .domain-accordion.expanded {
      border-color: var(--border-active);
      box-shadow: var(--shadow-md);
    }

    .domain-header {
      padding: 12px 14px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
      user-select: none;
      background: var(--bg-card);
    }

    .domain-title-group {
      display: flex;
      align-items: center;
      gap: 10px;
      flex: 1;
      min-width: 0;
    }

    .domain-num-badge {
      width: 28px;
      height: 28px;
      border-radius: 8px;
      background: rgba(99, 102, 241, 0.15);
      color: var(--brand-primary-light);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 800;
      flex-shrink: 0;
    }

    .domain-text {
      flex: 1;
      min-width: 0;
    }

    .domain-meta-tag {
      font-size: 10px;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--brand-primary-light);
      margin-bottom: 2px;
    }

    .domain-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 13.5px;
      font-weight: 800;
      color: var(--text-primary);
      line-height: 1.3;
    }

    .domain-subtopics-count {
      font-size: 11px;
      color: var(--text-muted);
      margin-top: 2px;
    }

    .domain-expand-icon {
      font-size: 14px;
      color: var(--text-muted);
      transition: transform var(--transition-normal);
      margin-left: 8px;
    }

    .domain-accordion.expanded .domain-expand-icon {
      transform: rotate(180deg);
      color: var(--brand-primary-light);
    }

    .subtopics-body {
      display: none;
      padding: 0 14px 14px;
      background: var(--bg-surface);
      border-top: 1px solid var(--border-subtle);
    }

    .domain-accordion.expanded .subtopics-body {
      display: block;
    }

    .domain-treatise {
      font-size: 11.5px;
      line-height: 1.5;
      color: var(--text-secondary);
      background: var(--bg-app);
      padding: 10px 12px;
      border-radius: var(--radius-sm);
      border-left: 3px solid var(--brand-primary);
      margin: 12px 0;
    }

    .subtopic-item {
      background: var(--bg-card);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-sm);
      padding: 11px 12px;
      margin-bottom: 8px;
      cursor: pointer;
      transition: all var(--transition-fast);
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .subtopic-item:hover {
      background: var(--bg-card-hover);
      border-color: var(--brand-primary);
      transform: translateX(2px);
    }

    .subtopic-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .subtopic-name {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-primary);
      flex: 1;
    }

    .subtopic-diff-badge {
      font-size: 9.5px;
      font-weight: 800;
      padding: 2px 6px;
      border-radius: var(--radius-xs);
      background: rgba(99, 102, 241, 0.2);
      color: var(--brand-primary-light);
      margin-left: 8px;
    }

    .subtopic-quick-ans {
      font-size: 11.5px;
      color: var(--text-secondary);
      line-height: 1.45;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .subtopic-footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 4px;
      padding-top: 6px;
      border-top: 1px solid var(--border-subtle);
      font-size: 10.5px;
      color: var(--text-muted);
    }

    .subtopic-cta {
      color: var(--brand-primary-light);
      font-weight: 700;
    }

    /* SPECIAL SECTIONS STYLING (Cards, Q-Items, Badges) */
    .special-section-view {
      display: none;
      animation: fadeIn 0.2s ease;
    }

    .special-section-view.active {
      display: block;
    }

    .section-hero-card {
      background: var(--brand-gradient);
      border-radius: var(--radius-md);
      padding: 14px 16px;
      color: #fff;
      margin-bottom: 14px;
      box-shadow: var(--shadow-md);
    }

    .section-hero-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 16px;
      font-weight: 800;
      margin-bottom: 4px;
    }

    .section-hero-sub {
      font-size: 11.5px;
      opacity: 0.9;
      line-height: 1.4;
    }

    .card {
      background: var(--bg-surface);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-sm);
      padding: 14px;
      margin-bottom: 10px;
      box-shadow: var(--shadow-sm);
    }

    .card h4 {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 8px;
      line-height: 1.4;
    }

    .card p, .card ul {
      font-size: 12px;
      color: var(--text-secondary);
      line-height: 1.5;
    }

    .card ul {
      padding-left: 16px;
      margin-top: 6px;
    }

    .card li {
      margin-bottom: 4px;
    }

    .q-list {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .q-item {
      background: var(--bg-card);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-sm);
      padding: 11px 13px;
      font-size: 12px;
      line-height: 1.5;
      color: var(--text-secondary);
    }

    .lvl-badge {
      display: inline-block;
      padding: 2px 6px;
      font-size: 9.5px;
      font-weight: 800;
      border-radius: var(--radius-xs);
      text-transform: uppercase;
      margin-right: 6px;
    }

    .lvl-senior { background: #fee2e2; color: #991b1b; }
    .lvl-mid { background: #fef3c7; color: #92400e; }
    .lvl-junior { background: #d1fae5; color: #065f46; }
    .lvl-lead { background: #e0e7ff; color: #3730a3; }

    .domain-title {
      font-size: 15px;
      font-weight: 800;
      color: var(--text-primary);
      margin: 12px 0 8px;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .topic-title {
      font-size: 13.5px;
      font-weight: 700;
      color: var(--brand-primary-light);
      margin: 14px 0 8px;
    }

    pre, .codehilite pre {
      background: var(--bg-code);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-xs);
      padding: 10px 12px;
      font-family: 'Fira Code', monospace;
      font-size: 11px;
      overflow-x: auto;
      margin: 8px 0;
      color: #38bdf8;
      line-height: 1.45;
    }

    code {
      font-family: 'Fira Code', monospace;
      font-size: 11px;
      background: rgba(99, 102, 241, 0.12);
      padding: 1px 4px;
      border-radius: 4px;
      color: var(--brand-primary-light);
    }

    /* BOTTOM FLOATING DOCK */
    .bottom-dock {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 72px;
      background: rgba(20, 27, 41, 0.88);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border-top: 1px solid var(--border-medium);
      display: flex;
      align-items: center;
      justify-content: space-around;
      padding: 0 10px 18px;
      z-index: 95;
    }

    [data-theme="light"] .bottom-dock {
      background: rgba(255, 255, 255, 0.9);
    }

    .dock-tab {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 3px;
      color: var(--text-muted);
      cursor: pointer;
      font-size: 10px;
      font-weight: 700;
      transition: all var(--transition-fast);
      flex: 1;
      padding: 4px 0;
      background: none;
      border: none;
    }

    .dock-tab.active {
      color: var(--brand-primary-light);
    }

    .dock-icon {
      font-size: 18px;
      transition: transform var(--transition-spring);
    }

    .dock-tab.active .dock-icon {
      transform: scale(1.18) translateY(-1px);
    }

    .home-indicator {
      position: absolute;
      bottom: 6px;
      left: 50%;
      transform: translateX(-50%);
      width: 134px;
      height: 5px;
      background: var(--text-muted);
      opacity: 0.5;
      border-radius: var(--radius-full);
      pointer-events: none;
    }

    /* MODAL SHEET INSPECTOR */
    .modal-overlay {
      position: absolute;
      inset: 0;
      background: rgba(0, 0, 0, 0.7);
      backdrop-filter: blur(8px);
      z-index: 150;
      display: none;
      align-items: flex-end;
      opacity: 0;
      transition: opacity var(--transition-normal);
    }

    .modal-overlay.open {
      display: flex;
      opacity: 1;
    }

    .bottom-sheet {
      width: 100%;
      max-height: 85%;
      background: var(--bg-surface);
      border-top-left-radius: var(--radius-xl);
      border-top-right-radius: var(--radius-xl);
      padding: 16px 18px 30px;
      border-top: 1px solid var(--border-medium);
      box-shadow: var(--shadow-lg);
      transform: translateY(100%);
      transition: transform var(--transition-spring);
      display: flex;
      flex-direction: column;
    }

    .modal-overlay.open .bottom-sheet {
      transform: translateY(0);
    }

    .sheet-handle {
      width: 38px;
      height: 4px;
      background: var(--border-medium);
      border-radius: var(--radius-full);
      margin: 0 auto 12px;
      cursor: pointer;
    }

    .sheet-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      margin-bottom: 12px;
    }

    .sheet-topic-badge {
      font-size: 10px;
      font-weight: 800;
      color: var(--brand-primary-light);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .sheet-topic-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 17px;
      font-weight: 800;
      color: var(--text-primary);
      margin-top: 2px;
      line-height: 1.25;
    }

    .sheet-close-btn {
      width: 28px;
      height: 28px;
      border-radius: var(--radius-full);
      background: var(--bg-surface-elevated);
      border: 1px solid var(--border-subtle);
      color: var(--text-secondary);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      cursor: pointer;
    }

    .sheet-tabs {
      display: flex;
      gap: 6px;
      border-bottom: 1px solid var(--border-subtle);
      padding-bottom: 8px;
      margin-bottom: 12px;
      overflow-x: auto;
    }

    .sheet-tabs::-webkit-scrollbar { display: none; }

    .sheet-tab-btn {
      padding: 6px 12px;
      border-radius: var(--radius-full);
      background: transparent;
      border: 1px solid transparent;
      color: var(--text-secondary);
      font-size: 11px;
      font-weight: 700;
      cursor: pointer;
      white-space: nowrap;
    }

    .sheet-tab-btn.active {
      background: rgba(99, 102, 241, 0.15);
      border-color: rgba(99, 102, 241, 0.3);
      color: var(--brand-primary-light);
    }

    .sheet-body-scroll {
      flex: 1;
      overflow-y: auto;
      padding-right: 4px;
    }

    .sheet-body-scroll::-webkit-scrollbar { width: 4px; }
    .sheet-body-scroll::-webkit-scrollbar-thumb {
      background: var(--border-medium);
      border-radius: 4px;
    }

    .explanation-section {
      display: none;
    }

    .explanation-section.active {
      display: block;
    }

    .info-card {
      background: var(--bg-card);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-sm);
      padding: 12px;
      margin-bottom: 10px;
    }

    .info-card h4 {
      font-size: 11px;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--brand-primary-light);
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .info-card p {
      font-size: 12.5px;
      line-height: 1.55;
      color: var(--text-primary);
    }

    .ascii-box {
      background: var(--bg-code);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-xs);
      padding: 10px 12px;
      font-family: 'Fira Code', monospace;
      font-size: 10.5px;
      line-height: 1.35;
      color: #38bdf8;
      overflow-x: auto;
      white-space: pre;
    }

    .code-box {
      background: var(--bg-code);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-xs);
      padding: 10px 12px;
      font-family: 'Fira Code', monospace;
      font-size: 11px;
      line-height: 1.45;
      color: #a5b4fc;
      overflow-x: auto;
      white-space: pre-wrap;
    }

    /* RIGHT: DESKTOP SIDECAR */
    .desktop-sidecar {
      flex: 1;
      max-width: 500px;
      height: 860px;
      background: var(--bg-surface);
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-xl);
      padding: 24px;
      display: flex;
      flex-direction: column;
      box-shadow: var(--shadow-md);
    }

    .sidecar-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 16px;
      padding-bottom: 12px;
      border-bottom: 1px solid var(--border-subtle);
    }

    .sidecar-title {
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 18px;
      font-weight: 800;
      color: var(--text-primary);
    }

    .sidecar-tree-scroll {
      flex: 1;
      overflow-y: auto;
      padding-right: 6px;
    }

    .sidecar-tree-scroll::-webkit-scrollbar {
      width: 5px;
    }
    .sidecar-tree-scroll::-webkit-scrollbar-thumb {
      background: var(--border-medium);
      border-radius: 4px;
    }

    .tree-domain-group {
      margin-bottom: 12px;
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-sm);
      background: var(--bg-card);
      overflow: hidden;
    }

    .tree-domain-title {
      padding: 10px 12px;
      font-size: 12.5px;
      font-weight: 700;
      color: var(--text-primary);
      background: var(--bg-surface-elevated);
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
    }

    .tree-topic-list {
      padding: 8px 12px;
    }

    .tree-topic-link {
      padding: 6px 0;
      font-size: 12px;
      color: var(--text-secondary);
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
      border-bottom: 1px solid rgba(255, 255, 255, 0.04);
      transition: color var(--transition-fast);
    }

    .tree-topic-link:last-child {
      border-bottom: none;
    }

    .tree-topic-link:hover {
      color: var(--brand-primary-light);
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(4px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

  <div class="showcase-wrapper">
    <header class="showcase-header">
      <div class="badge-pill">✨ 32 Domains • 128 Topics • Complete Master Reference Banks</div>
      <h1 class="showcase-title">handyLearn Full-Scale iOS Lead Preparation Architecture</h1>
      <p class="showcase-desc">
        Designed to handle enterprise-scale technical depth. Seamlessly browse, search, and deep-dive into all 
        <strong>32 Canonical Architectural Domains</strong> and <strong>All Master Question & Scenario Banks</strong> (Senior 100, Exam 89, Git Masterclass, 5 Mobile System Designs, Staff Signals, & Career Progression).
      </p>

      <div class="showcase-controls">
        <button class="control-btn" id="themeToggleBtn" onclick="toggleTheme()">
          <span id="themeIcon">☀️</span> Light / Dark Mode
        </button>
        <button class="control-btn active" id="filterBtnAll" onclick="switchMainView('domains'); setMobileFilter('all', this)">All 32 Domains</button>
        <button class="control-btn" onclick="switchMainView('senior-100')">🎯 Senior 100 Q&A</button>
        <button class="control-btn" onclick="switchMainView('exam-89')">📝 89-Question Exam</button>
        <button class="control-btn" onclick="switchMainView('git-puzzles')">⚡ Git Masterclass (33)</button>
        <button class="control-btn" onclick="switchMainView('staff-designs')">🌟 Staff Signals & Designs</button>
      </div>
    </header>

    <div class="prototype-container">
      
      <!-- LEFT: IPHONE 16 PRO MOBILE CANVAS -->
      <div class="device-shell">
        <div class="device-screen">
          
          <div class="dynamic-island-wrapper">
            <div class="dynamic-island">
              <div class="camera-lens"></div>
              <div class="face-id-sensor"></div>
            </div>
          </div>

          <div class="status-bar">
            <span id="statusBarTime">9:41</span>
            <div style="display: flex; gap: 5px;">
              <span>􀙇</span>
              <span>􀐚</span>
              <span>􀛨</span>
            </div>
          </div>

          <header class="app-header">
            <div class="brand-group">
              <div class="app-logo-badge">h</div>
              <div>
                <div class="brand-title">handyLearn</div>
                <div class="brand-stats-sub" id="brandHeaderStats">32 DOMAINS • 128 TOPICS</div>
              </div>
            </div>
            <div class="header-actions">
              <button class="icon-btn" onclick="toggleTheme()" title="Toggle Theme">🌓</button>
            </div>
          </header>

          <div class="app-viewport">
            
            <!-- 1. DOMAINS VIEW CONTAINER -->
            <div id="viewContainer-domains" class="special-section-view active">
              <div class="mobile-search-bar">
                <div class="search-input-wrap">
                  <span class="search-icon-pre">🔍</span>
                  <input 
                    type="text" 
                    id="mobileSearchInput"
                    class="search-input-box" 
                    placeholder="Search 128 topics (e.g. Actor, ARC, COW, Jetsam)..." 
                    oninput="handleSearch(this.value)"
                  />
                  <span class="search-count-badge" id="searchCountBadge">128 Topics</span>
                </div>
              </div>

              <div class="chips-rail">
                <div class="chip-item active" onclick="setMobileFilter('all', this)">All Domains</div>
                <div class="chip-item" onclick="setMobileFilter('Core Swift', this)">⚡ Core Swift</div>
                <div class="chip-item" onclick="setMobileFilter('Memory', this)">🧠 Memory & ARC</div>
                <div class="chip-item" onclick="setMobileFilter('Concurrency', this)">🔀 Concurrency</div>
                <div class="chip-item" onclick="setMobileFilter('UI', this)">🎨 SwiftUI & UIKit</div>
                <div class="chip-item" onclick="setMobileFilter('Architecture', this)">🏛️ Architecture</div>
                <div class="chip-item" onclick="setMobileFilter('System Design', this)">📐 System Design</div>
              </div>

              <div id="domainsAccordionList">
                <!-- Rendered dynamically -->
              </div>
            </div>

            <!-- 2. SENIOR 100 VIEW -->
            <div id="viewContainer-senior-100" class="special-section-view">
              <div class="section-hero-card">
                <div class="section-hero-title">Senior 100 Real-World Interview Q&A</div>
                <div class="section-hero-sub">Production scenarios synthesized across fintech, e-commerce, and high-scale consumer iOS architectures.</div>
              </div>
              <div id="senior100Content"></div>
            </div>

            <!-- 3. EXAM 89 VIEW -->
            <div id="viewContainer-exam-89" class="special-section-view">
              <div class="section-hero-card">
                <div class="section-hero-title">89-Question Technical Examination Bank</div>
                <div class="section-hero-sub">Experience-tagged interview questions calibrated for Junior, Mid, Senior, and Lead levels.</div>
              </div>
              <div id="exam89Content"></div>
            </div>

            <!-- 4. GIT PUZZLES VIEW -->
            <div id="viewContainer-git-puzzles" class="special-section-view">
              <div class="section-hero-card">
                <div class="section-hero-title">Git Masterclass & Lead Concurrency Puzzles</div>
                <div class="section-hero-sub">33 production crisis engineering disaster scenarios and step-by-step terminal recovery workflows.</div>
              </div>
              <div id="gitPuzzlesContent"></div>
            </div>

            <!-- 5. STAFF SIGNALS & DESIGNS VIEW -->
            <div id="viewContainer-staff-designs" class="special-section-view">
              <div class="section-hero-card">
                <div class="section-hero-title">16 Staff Signals & Mobile System Designs</div>
                <div class="section-hero-sub">Tier-1 calibration signals, architectural defense playbooks, and career progression rubrics.</div>
              </div>
              <div style="display:flex; gap:6px; margin-bottom:12px; overflow-x:auto;">
                <button class="chip-item active" onclick="switchStaffSubSection('sysdesign', this)">📐 5 System Designs</button>
                <button class="chip-item" onclick="switchStaffSubSection('signals', this)">🌟 16 Staff Signals</button>
                <button class="chip-item" onclick="switchStaffSubSection('defense', this)">🛡️ Enterprise Defense</button>
                <button class="chip-item" onclick="switchStaffSubSection('rubric', this)">📊 Career Rubric</button>
              </div>
              <div id="staffDesignsSubContent"></div>
            </div>

          </div>

          <!-- BOTTOM DOCK NAVIGATION -->
          <nav class="bottom-dock">
            <button class="dock-tab active" id="dockTab-domains" onclick="switchMainView('domains')">
              <span class="dock-icon">📚</span>
              <span>Domains</span>
            </button>
            <button class="dock-tab" id="dockTab-senior-100" onclick="switchMainView('senior-100')">
              <span class="dock-icon">🎯</span>
              <span>Senior 100</span>
            </button>
            <button class="dock-tab" id="dockTab-exam-89" onclick="switchMainView('exam-89')">
              <span class="dock-icon">📝</span>
              <span>Exam 89</span>
            </button>
            <button class="dock-tab" id="dockTab-git-puzzles" onclick="switchMainView('git-puzzles')">
              <span class="dock-icon">⚡</span>
              <span>Git (33)</span>
            </button>
            <button class="dock-tab" id="dockTab-staff-designs" onclick="switchMainView('staff-designs')">
              <span class="dock-icon">🌟</span>
              <span>Staff & Sys</span>
            </button>
          </nav>

          <div class="home-indicator"></div>

          <!-- MODAL SHEET: TOPIC DEEP DIVE & EXPLANATION -->
          <div class="modal-overlay" id="topicDetailModal" onclick="closeTopicModal(event)">
            <div class="bottom-sheet" onclick="event.stopPropagation()">
              <div class="sheet-handle" onclick="closeTopicModal()"></div>
              
              <div class="sheet-header">
                <div>
                  <div class="sheet-topic-badge" id="sheetDomainTag">DOMAIN 01 • VALUE VS REFERENCE</div>
                  <div class="sheet-topic-title" id="sheetTopicTitle">Value vs Reference Semantics</div>
                </div>
                <button class="sheet-close-btn" onclick="closeTopicModal()">✕</button>
              </div>

              <div class="sheet-tabs">
                <button class="sheet-tab-btn active" onclick="switchSheetTab('quick', this)">Quick Answer</button>
                <button class="sheet-tab-btn" onclick="switchSheetTab('mental', this)">Mental Model</button>
                <button class="sheet-tab-btn" onclick="switchSheetTab('code', this)">Swift 6 Code</button>
                <button class="sheet-tab-btn" onclick="switchSheetTab('staff', this)">Staff Signal</button>
              </div>

              <div class="sheet-body-scroll">
                <div class="explanation-section active" id="sheetSection-quick">
                  <div class="info-card">
                    <h4>💡 Quick Calibration Answer</h4>
                    <p id="sheetQuickAnswerText"></p>
                  </div>
                  <div class="info-card">
                    <h4>🎯 Why It Matters to Engineering Leads</h4>
                    <p id="sheetWhyItMattersText"></p>
                  </div>
                </div>

                <div class="explanation-section" id="sheetSection-mental">
                  <div class="info-card">
                    <h4>📐 Architectural Mental Model</h4>
                    <div class="ascii-box" id="sheetMentalModelText"></div>
                  </div>
                </div>

                <div class="explanation-section" id="sheetSection-code">
                  <div class="info-card">
                    <h4>💻 Production Swift 6 Implementation</h4>
                    <div class="code-box" id="sheetCodeText"></div>
                  </div>
                </div>

                <div class="explanation-section" id="sheetSection-staff">
                  <div class="info-card">
                    <h4>🌟 Staff & Principal Calibration Signals</h4>
                    <div id="sheetStaffSignalsText" style="font-size: 12px; line-height: 1.5;"></div>
                  </div>
                </div>
              </div>

            </div>
          </div>

        </div>
      </div>

      <!-- RIGHT: DESKTOP CURRICULUM TREE SIDECAR -->
      <div class="desktop-sidecar">
        <div class="sidecar-header">
          <div>
            <div class="sidecar-title">Master Curriculum Hierarchy</div>
            <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
              Click any subtopic to inspect inside the mobile prototype
            </div>
          </div>
          <span class="badge-pill">32 Domains</span>
        </div>

        <div class="sidecar-tree-scroll" id="desktopTreeContainer">
          <!-- Rendered dynamically -->
        </div>
      </div>

    </div>
  </div>

  <script>
    // Embedded 32 Domains & 128 Topics Master Data
    const DOMAINS_DATA = ''' + json.dumps(domains) + ''';
    const SPECIAL_SECTIONS = ''' + json.dumps(special_sections) + ''';

    let currentFilter = 'all';
    let searchQuery = '';
    let currentTopic = null;
    let currentMainView = 'domains';

    function init() {
      renderMobileDomains();
      renderDesktopTree();
      renderSpecialSections();
      updateClock();
      setInterval(updateClock, 1000);

      const savedTheme = localStorage.getItem('handylearn_theme') || 'dark';
      document.documentElement.setAttribute('data-theme', savedTheme);
      document.getElementById('themeIcon').textContent = savedTheme === 'dark' ? '☀️' : '🌙';
    }

    function switchMainView(viewKey) {
      currentMainView = viewKey;

      // Update dock buttons
      document.querySelectorAll('.dock-tab').forEach(b => b.classList.remove('active'));
      const activeDock = document.getElementById(`dockTab-${viewKey}`);
      if (activeDock) activeDock.classList.add('active');

      // Update main views
      document.querySelectorAll('.special-section-view').forEach(v => v.classList.remove('active'));
      const targetView = document.getElementById(`viewContainer-${viewKey}`);
      if (targetView) targetView.classList.add('active');

      // Update header subtitle
      const statsEl = document.getElementById('brandHeaderStats');
      if (viewKey === 'domains') {
        statsEl.textContent = '32 DOMAINS • 128 TOPICS';
      } else if (viewKey === 'senior-100') {
        statsEl.textContent = '100 SENIOR REAL-WORLD Q&A';
      } else if (viewKey === 'exam-89') {
        statsEl.textContent = '89-QUESTION EXAM BANK';
      } else if (viewKey === 'git-puzzles') {
        statsEl.textContent = '33 GIT RECOVERY PUZZLES';
      } else if (viewKey === 'staff-designs') {
        statsEl.textContent = 'STAFF SIGNALS & 5 SYSTEM DESIGNS';
      }

      // Scroll viewport to top
      document.querySelector('.app-viewport').scrollTop = 0;
    }

    function renderSpecialSections() {
      // 1. Senior 100
      if (SPECIAL_SECTIONS['senior-100']) {
        document.getElementById('senior100Content').innerHTML = SPECIAL_SECTIONS['senior-100'].htmlContent;
      }
      // 2. Exam 89
      if (SPECIAL_SECTIONS['exam-89']) {
        document.getElementById('exam89Content').innerHTML = SPECIAL_SECTIONS['exam-89'].htmlContent;
      }
      // 3. Git Puzzles
      if (SPECIAL_SECTIONS['git-puzzles']) {
        document.getElementById('gitPuzzlesContent').innerHTML = SPECIAL_SECTIONS['git-puzzles'].htmlContent;
      }
      // 4. Staff & Designs sub-sections
      switchStaffSubSection('sysdesign', document.querySelectorAll('#viewContainer-staff-designs .chip-item')[0]);
    }

    function switchStaffSubSection(subKey, btn) {
      if (btn) {
        document.querySelectorAll('#viewContainer-staff-designs .chip-item').forEach(c => c.classList.remove('active'));
        btn.classList.add('active');
      }

      const container = document.getElementById('staffDesignsSubContent');
      if (subKey === 'sysdesign' && SPECIAL_SECTIONS['system-designs']) {
        container.innerHTML = SPECIAL_SECTIONS['system-designs'].htmlContent;
      } else if (subKey === 'signals' && SPECIAL_SECTIONS['staff-signals']) {
        container.innerHTML = SPECIAL_SECTIONS['staff-signals'].htmlContent;
      } else if (subKey === 'defense' && SPECIAL_SECTIONS['enterprise-defense']) {
        container.innerHTML = SPECIAL_SECTIONS['enterprise-defense'].htmlContent;
      } else if (subKey === 'rubric' && SPECIAL_SECTIONS['career-rubric']) {
        container.innerHTML = SPECIAL_SECTIONS['career-rubric'].htmlContent;
      }
    }

    function renderMobileDomains() {
      const container = document.getElementById('domainsAccordionList');
      container.innerHTML = '';

      let matchingTopicCount = 0;
      const q = searchQuery.toLowerCase().trim();

      DOMAINS_DATA.forEach((domain, idx) => {
        // Tag filtering
        if (currentFilter !== 'all' && domain.tag !== currentFilter && !domain.title.toLowerCase().includes(currentFilter.toLowerCase())) {
          return;
        }

        // Search filtering
        const filteredTopics = domain.topics.filter(t => {
          if (!q) return true;
          return t.title.toLowerCase().includes(q) ||
                 t.quickAnswer.toLowerCase().includes(q) ||
                 domain.title.toLowerCase().includes(q) ||
                 t.whyItMatters.toLowerCase().includes(q);
        });

        if (q && filteredTopics.length === 0 && !domain.title.toLowerCase().includes(q)) {
          return;
        }

        matchingTopicCount += filteredTopics.length;

        const domainEl = document.createElement('div');
        domainEl.className = `domain-accordion ${idx === 0 || q.length > 0 ? 'expanded' : ''}`;
        domainEl.id = `domain-acc-${domain.id}`;

        domainEl.innerHTML = `
          <div class="domain-header" onclick="toggleDomainAccordion(${domain.id})">
            <div class="domain-title-group">
              <div class="domain-num-badge">${domain.domainNumber}</div>
              <div class="domain-text">
                <div class="domain-meta-tag">${domain.tag} • ${domain.difficulty}</div>
                <div class="domain-title">${domain.title}</div>
                <div class="domain-subtopics-count">${filteredTopics.length} Subtopics Available</div>
              </div>
            </div>
            <div class="domain-expand-icon">▾</div>
          </div>

          <div class="subtopics-body">
            <div class="domain-treatise">
              ${domain.architecturalTreatise ? domain.architecturalTreatise.substring(0, 180) : ''}...
            </div>
            <div class="subtopics-list">
              ${filteredTopics.map(topic => `
                <div class="subtopic-item" onclick="openTopicById('${topic.id}')">
                  <div class="subtopic-top">
                    <span class="subtopic-name">${topic.title}</span>
                    <span class="subtopic-diff-badge">${topic.difficulty}</span>
                  </div>
                  <div class="subtopic-quick-ans">${topic.quickAnswer}</div>
                  <div class="subtopic-footer">
                    <span>⏱️ 15 min deep-dive</span>
                    <span class="subtopic-cta">Explore Topic & Code →</span>
                  </div>
                </div>
              `).join('')}
            </div>
          </div>
        `;

        container.appendChild(domainEl);
      });

      document.getElementById('searchCountBadge').textContent = `${matchingTopicCount} Topics`;
    }

    function renderDesktopTree() {
      const container = document.getElementById('desktopTreeContainer');
      container.innerHTML = '';

      DOMAINS_DATA.forEach(domain => {
        const group = document.createElement('div');
        group.className = 'tree-domain-group';
        group.innerHTML = `
          <div class="tree-domain-title" onclick="toggleTreeDomain('tree-topics-${domain.id}')">
            <span><strong>D${domain.domainNumber}:</strong> ${domain.title}</span>
            <span style="font-size: 11px; opacity: 0.7;">${domain.topics.length} topics</span>
          </div>
          <div class="tree-topic-list" id="tree-topics-${domain.id}">
            ${domain.topics.map(t => `
              <div class="tree-topic-link" onclick="openTopicById('${t.id}')">
                <span>• ${t.title}</span>
                <span style="font-size: 10px; color: var(--brand-primary-light);">${t.difficulty}</span>
              </div>
            `).join('')}
          </div>
        `;
        container.appendChild(group);
      });
    }

    function toggleTreeDomain(id) {
      const el = document.getElementById(id);
      if (el) el.style.display = el.style.display === 'none' ? 'block' : 'none';
    }

    function toggleDomainAccordion(id) {
      const el = document.getElementById(`domain-acc-${id}`);
      if (el) el.classList.toggle('expanded');
    }

    function filterByTag(tag) {
      currentFilter = tag;
      renderMobileDomains();
    }

    function setMobileFilter(tag, chipBtn) {
      document.querySelectorAll('.chips-rail .chip-item').forEach(c => c.classList.remove('active'));
      chipBtn.classList.add('active');
      filterByTag(tag);
    }

    function handleSearch(val) {
      searchQuery = val;
      renderMobileDomains();
    }

    function openTopicById(topicId) {
      switchMainView('domains');
      for (const d of DOMAINS_DATA) {
        for (const t of d.topics) {
          if (t.id === topicId) {
            currentTopic = t;
            document.getElementById('sheetDomainTag').textContent = `DOMAIN ${d.domainNumber} • ${d.tag}`;
            document.getElementById('sheetTopicTitle').textContent = t.title;
            document.getElementById('sheetQuickAnswerText').textContent = t.quickAnswer;
            document.getElementById('sheetWhyItMattersText').textContent = t.whyItMatters;
            document.getElementById('sheetMentalModelText').textContent = t.mentalModel;
            document.getElementById('sheetCodeText').textContent = t.productionCode;

            const signalsHtml = d.staffSignals && d.staffSignals.length > 0 
              ? d.staffSignals.map(s => `<div style="padding: 6px 8px; margin-bottom: 6px; border-radius: 6px; background: rgba(99, 102, 241, 0.08);">${s}</div>`).join('')
              : '<p>Standard Senior/Staff evaluation rubric applies.</p>';
            document.getElementById('sheetStaffSignalsText').innerHTML = signalsHtml;

            switchSheetTab('quick', document.querySelectorAll('.sheet-tab-btn')[0]);
            document.getElementById('topicDetailModal').classList.add('open');
            return;
          }
        }
      }
    }

    function closeTopicModal(e) {
      if (!e || e.target.id === 'topicDetailModal' || e.target.classList.contains('sheet-close-btn') || e.target.classList.contains('sheet-handle')) {
        document.getElementById('topicDetailModal').classList.remove('open');
      }
    }

    function switchSheetTab(tabKey, btn) {
      document.querySelectorAll('.sheet-tab-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      document.querySelectorAll('.explanation-section').forEach(s => s.classList.remove('active'));
      const target = document.getElementById(`sheetSection-${tabKey}`);
      if (target) target.classList.add('active');
    }

    function toggleTheme() {
      const current = document.documentElement.getAttribute('data-theme') || 'dark';
      const next = current === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem('handylearn_theme', next);
      document.getElementById('themeIcon').textContent = next === 'dark' ? '☀️' : '🌙';
    }

    function updateClock() {
      const now = new Date();
      let hours = now.getHours();
      let minutes = now.getMinutes();
      minutes = minutes < 10 ? '0' + minutes : minutes;
      document.getElementById('statusBarTime').textContent = `${hours}:${minutes}`;
    }

    window.addEventListener('DOMContentLoaded', init);
  </script>
</body>
</html>
'''

with open('handyLearn/design/mobile_app.html', 'w', encoding='utf-8') as f:
    f.write(html_template)

print('Updated handyLearn/design/mobile_app.html with all 32 domains AND all 7 Master Reference Banks successfully!')
