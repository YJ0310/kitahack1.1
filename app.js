// 1. 加载环境变量（Gemini API Key）
require('dotenv').config();

// 2. 导入核心依赖
const express = require('express');
const cors = require('cors');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const { db } = require('./firebase-config');
// 4. 初始化 Express 应用
const app = express();
const PORT = 3000;

// 5. 跨域配置（适配前端）
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// ==================== API 开始 ====================

// 1. GET /api/tags/search - 标签搜索（适配 Tags 集合）
app.get('/api/tags/search', async (req, res) => {
  try {
    const { q } = req.query;
    
    if (!q) {
      return res.status(400).json({ error: '查询关键词 q 是必填参数' });
    }

    // 对接 Jiaqian 的 Tags 集合（首字母大写）
    const tagsRef = db.collection('Tags');
    const snapshot = await tagsRef.get();
    const matchedTags = [];

    snapshot.forEach(doc => {
      const tagData = doc.data();
      // 只按 name 搜索，匹配大小写不敏感
      if (tagData.name.toLowerCase().includes(q.toLowerCase())) {
        matchedTags.push({
          id: doc.id,       // Tags 集合的文档ID（对应 tag_id）
          name: tagData.name,
          category_id: tagData.category_id
        });
      }
    });

    res.status(200).json(matchedTags);

  } catch (error) {
    console.error('标签搜索失败：', error);
    res.status(500).json({ error: '服务器内部错误，请稍后重试' });
  }
});

// 2. GET /api/users - 获取所有用户（适配 Users 集合）
app.get('/api/users', async (req, res) => {
  try {
    // 对接 Jiaqian 的 Users 集合（首字母大写）
    const usersRef = db.collection('Users');
    const snapshot = await usersRef.get();

    if (snapshot.empty) {
      return res.status(200).json([]);
    }

    const users = [];
    snapshot.forEach(doc => {
      const userData = doc.data();
      users.push({
        id: doc.id,                  // 用户ID
        name: userData.name,         // 用户名
        email: userData.email,       // 用户邮箱
        skill_tags: userData.skill_tags || [], // 技能标签（适配真实字段）
        major_id: userData.major_id, // 专业ID
        dev_tags: userData.dev_tags || [],
        courses_id: userData.courses_id || []
      });
    });

    res.status(200).json(users);

  } catch (error) {
    console.error('获取用户列表失败：', error);
    res.status(500).json({ error: '服务器内部错误，请稍后重试' });
  }
});

// 3. GET /api/users/:id - 获取单个用户详情
app.get('/api/users/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const userRef = db.collection('Users').doc(userId);
    const doc = await userRef.get();

    if (!doc.exists) {
      return res.status(404).json({ error: '用户不存在' });
    }

    res.status(200).json({
      id: doc.id,
      ...doc.data()
    });

  } catch (error) {
    console.error('获取用户详情失败：', error);
    res.status(500).json({ error: '服务器内部错误，请稍后重试' });
  }
});

// 4. POST /api/teams/generate - 生成团队（适配 Posts/Users 集合）
app.post('/api/teams/generate', async (req, res) => {
  try {
    const { postId, memberCount } = req.body;

    // 校验必填参数
    if (!postId || !memberCount) {
      return res.status(400).json({
        error: 'postId（项目ID）和 memberCount（团队人数）是必填参数'
      });
    }

    // 步骤1：从 Posts 集合获取项目需求标签（requirements 字段）
    const postRef = db.collection('Posts').doc(postId);
    const postDoc = await postRef.get();
    if (!postDoc.exists) {
      return res.status(404).json({ error: '项目不存在' });
    }
    const postData = postDoc.data();
    const requiredTagIds = postData.requirements || [];

    // 步骤2：筛选出技能标签包含项目需求的用户
    const usersRef = db.collection('Users');
    const usersSnapshot = await usersRef.get();
    const eligibleUsers = [];

    usersSnapshot.forEach(doc => {
      const userData = doc.data();
      // 提取用户的 tag_id 列表（适配 skill_tags 字段结构）
      const userSkillTagIds = (userData.skill_tags || []).map(item => item.tag_id);
      
      // 检查是否包含至少一个项目需求的 tag_id
      const hasRequiredTag = requiredTagIds.some(tagId => userSkillTagIds.includes(tagId));
      if (hasRequiredTag) {
        eligibleUsers.push({
          id: doc.id,
          name: userData.name,
          email: userData.email,
          skill_tags: userData.skill_tags
        });
      }
    });

    // 检查用户数量是否足够
    if (eligibleUsers.length < memberCount) {
      return res.status(400).json({
        error: `符合条件的用户只有 ${eligibleUsers.length} 人，无法组成 ${memberCount} 人的团队`
      });
    }

    // 步骤3：随机生成团队
    const shuffledUsers = [...eligibleUsers].sort(() => 0.5 - Math.random());
    const teamMembers = shuffledUsers.slice(0, memberCount);

    // 步骤4：存入 Teams 集合（自动创建）
    const newTeamData = {
      postId,
      projectName: postData.title || '未命名项目',
      requiredTagIds,
      memberCount,
      members: teamMembers.map(m => ({
        id: m.id,
        name: m.name,
        email: m.email
      })),
      createdAt: new Date()
    };
    const newTeamDoc = await db.collection('Teams').add(newTeamData);

    res.status(201).json({
      message: '团队生成成功',
      team: {
        id: newTeamDoc.id,
        ...newTeamData
      }
    });

  } catch (error) {
    console.error('生成团队失败：', error);
    res.status(500).json({ error: '服务器内部错误，请稍后重试' });
  }
});

// 5. GET /api/teams/:id - 获取单个团队详情
app.get('/api/teams/:id', async (req, res) => {
  try {
    const teamId = req.params.id;
    const teamRef = db.collection('Teams').doc(teamId);
    const doc = await teamRef.get();

    if (!doc.exists) {
      return res.status(404).json({ error: '团队不存在' });
    }

    res.status(200).json({
      id: doc.id,
      ...doc.data()
    });

  } catch (error) {
    console.error('获取团队详情失败：', error);
    res.status(500).json({ error: '服务器内部错误，请稍后重试' });
  }
});

// 6. POST /api/ai/analyze-team - Gemini AI 分析团队
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY || '');

app.post('/api/ai/analyze-team', async (req, res) => {
  try {
    const { teamId } = req.body;

    if (!teamId) {
      return res.status(400).json({ error: 'teamId（团队ID）是必填参数' });
    }

    // 1. 获取团队数据
    const teamRef = db.collection('Teams').doc(teamId);
    const teamDoc = await teamRef.get();
    if (!teamDoc.exists) {
      return res.status(404).json({ error: '团队不存在' });
    }
    const teamData = { id: teamDoc.id, ...teamDoc.data() };

    // 2. 获取标签名称（把 tag_id 转成标签名，方便 AI 分析）
    const tagIds = teamData.requiredTagIds || [];
    const tagNames = [];
    for (const tagId of tagIds) {
      const tagDoc = await db.collection('Tags').doc(tagId).get();
      if (tagDoc.exists) {
        tagNames.push(tagDoc.data().name);
      }
    }

    // 3. 调用 Gemini AI 分析
    if (!GEMINI_API_KEY) {
      return res.status(401).json({ error: '未配置 Gemini API Key' });
    }
    const model = genAI.getGenerativeModel({ 
      model: "gemini-1.5-flash",
      generationConfig: { temperature: 0.7, maxOutputTokens: 1000 }
    });

    const prompt = `
      你是专业的团队技能分析专家，请分析以下团队：
      1. 项目名称：${teamData.projectName}
      2. 项目需要的技能标签：${tagNames.join(', ')}（ID：${tagIds.join(', ')}）
      3. 团队人数：${teamData.memberCount}
      4. 团队成员：${JSON.stringify(teamData.members)}

      请按以下结构用中文输出分析结果：
      1. 技能匹配度总结：评估团队技能是否满足项目需求，给出百分比评分；
      2. 优势：团队当前的核心技能优势；
      3. 不足：缺少的关键技能或技能分布问题；
      4. 优化建议：针对不足给出具体的人员调整/技能补充建议。
    `;

    const result = await model.generateContent(prompt);
    const aiAnalysis = await result.response.text();

    // 4. 保存分析结果到团队文档
    await teamRef.update({
      aiAnalysis,
      aiAnalyzedAt: new Date()
    });

    res.status(200).json({
      message: '团队分析完成',
      teamId,
      analysis: aiAnalysis
    });

  } catch (error) {
    console.error('AI 分析失败：', error);
    res.status(500).json({ error: 'AI 分析失败，请稍后重试' });
  }
});

// ==================== API 结束 ====================

// 全局错误处理
app.use((err, req, res, next) => {
  console.error('全局错误：', err.stack);
  res.status(500).json({
    error: '服务器内部错误',
    message: err.message
  });
});

// 测试路由
app.get('/test', (req, res) => {
  res.send('服务器正常运行！');
});

// 启动服务器
app.listen(PORT, () => {
  console.log(`后端服务器运行在 http://localhost:${PORT}`);
});