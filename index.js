/**
 * Project Aletheia - Claude Code 插件
 *
 * 此文件用于导出和管理 agents、skills 和 hooks。
 *
 * 注意：Claude Code 会自动从以下目录加载配置：
 * - .claude/agents/ - 自定义代理（.md 文件）
 * - .claude/skills/ - 自定义技能（.md 文件）
 * - .claude/hooks/ - 事件钩子（.sh 文件）
 *
 * 本文件主要用于程序化访问和测试。
 */

import { readFileSync, readdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// 加载所有 agents
export function loadAgents() {
  const agentsDir = join(__dirname, 'agents');
  const files = readdirSync(agentsDir).filter(f => f.endsWith('.md'));
  return files.map(file => ({
    name: file.replace('.md', ''),
    content: readFileSync(join(agentsDir, file), 'utf-8')
  }));
}

// 加载所有 skills
export function loadSkills() {
  const skillsDir = join(__dirname, 'skills');
  const files = readdirSync(skillsDir).filter(f => f.endsWith('.md'));
  return files.map(file => ({
    name: file.replace('.md', ''),
    content: readFileSync(join(skillsDir, file), 'utf-8')
  }));
}

// 加载所有 hooks
export function loadHooks() {
  const hooksDir = join(__dirname, 'hooks');
  const files = readdirSync(hooksDir).filter(f => f.endsWith('.sh'));
  return files.map(file => ({
    name: file.replace('.sh', ''),
    content: readFileSync(join(hooksDir, file), 'utf-8')
  }));
}

// 导出所有资源
export default {
  loadAgents,
  loadSkills,
  loadHooks
};

