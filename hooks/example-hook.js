// 示例 hook
export default {
  name: 'example-hook',
  event: 'before-tool-call',
  handler: async (context) => {
    console.log('Hook 已触发');
  }
};
