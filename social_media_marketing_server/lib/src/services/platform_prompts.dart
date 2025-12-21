/// Platform-specific prompts and instructions for AI content generation.
/// Contains detailed guidelines for each social media platform.
class PlatformPrompts {
  /// Map of platform-specific content generation instructions
  static const Map<String, String> platformInstructions = {
    'x': '''
PLATFORM: X (Twitter)
CHARACTER LIMIT: 280 characters (strict maximum)
STYLE: Punchy, concise, and attention-grabbing
TONE: Conversational yet professional

REQUIREMENTS:
- Keep the post between 200-280 characters for optimal engagement
- Start with a strong hook that captures attention immediately
- Use 1-3 relevant hashtags (not more)
- Include emojis sparingly (1-2 max) only if they add value
- Make every word count - be direct and impactful
- Consider adding a call-to-action when appropriate
- Avoid thread format unless specifically requested
- Use line breaks strategically for readability

BEST PRACTICES:
- Focus on one key message per post
- Use numbers and statistics when relevant
- Ask questions to encourage engagement
- Share insights or tips that provide immediate value
- Include relevant industry hashtags for discoverability

AVOID:
- Hashtag spam (more than 3)
- Excessive emojis
- All caps (unless for emphasis)
- Long URLs (use link shorteners if needed)
''',

    'linkedin': '''
PLATFORM: LinkedIn
CHARACTER RANGE: 1000-1500 characters (optimal engagement)
STYLE: Professional, insightful, and thought-leadership oriented
TONE: Authoritative yet approachable

REQUIREMENTS:
- Open with a compelling hook (first 2 lines are critical - visible before "see more")
- Structure content with clear paragraphs and line breaks
- Include professional insights, industry trends, or valuable lessons
- Use a professional tone but remain conversational
- Add 3-5 relevant hashtags at the end
- Consider including a call-to-action for comments/discussions
- Use bullet points or numbered lists for readability when appropriate

BEST PRACTICES:
- Share personal experiences or case studies
- Provide actionable takeaways
- Ask thought-provoking questions
- Reference industry data or research when relevant
- Use storytelling to make content relatable
- End with an engaging question to drive comments
- First-person perspective works well

FORMATTING:
- Use line breaks between paragraphs
- Emojis are optional but use professionally (1-2 per post max)
- Bold key points using Unicode (if needed)
- Keep paragraphs to 2-3 lines for mobile readability

AVOID:
- Sales-heavy language
- Excessive self-promotion
- Clickbait tactics
- Overuse of hashtags (more than 5)
''',

    'instagram': '''
PLATFORM: Instagram
CHARACTER RANGE: 200-500 characters (caption length flexible but concise works best)
STYLE: Visual-first, engaging, and community-oriented
TONE: Authentic, relatable, and conversational

REQUIREMENTS:
- Write caption assuming the image/video carries primary message
- Open with an engaging hook or question
- Use emojis naturally throughout the text (3-8 emojis is normal)
- Include 5-10 relevant hashtags (can go up to 30 but 5-10 is optimal)
- Add line breaks for readability (Instagram allows this)
- Include a clear call-to-action
- Tag relevant accounts if applicable

BEST PRACTICES:
- First line is critical (appears in feed before "more")
- Use emojis as visual breaks and to convey emotion
- Tell micro-stories that complement the visual
- Ask questions to drive comments
- Share behind-the-scenes insights
- Use mix of popular and niche hashtags
- Create hashtag groups at the end or in first comment
- Encourage tagging, sharing, or saving

FORMATTING:
- Use emojis as bullet points
- Add line breaks (use periods or dashes on blank lines)
- Consider carousel-style numbering if applicable
- Keep sentences short and punchy

HASHTAG STRATEGY:
- Mix of branded, industry, and trending hashtags
- Place hashtags at the end after line breaks
- Group related hashtags together

AVOID:
- Walls of text without breaks
- Overuse of hashtags (more than 15 can look spammy)
- Overly corporate or stiff language
''',

    'facebook': '''
PLATFORM: Facebook
CHARACTER RANGE: 100-400 characters (shorter posts perform better)
STYLE: Conversational, engaging, and community-focused
TONE: Friendly, approachable, and relatable

REQUIREMENTS:
- Write in a warm, conversational tone
- Focus on driving engagement (likes, comments, shares)
- Include a clear call-to-action
- Use emojis moderately (2-5 per post)
- Keep paragraphs short for mobile readability
- Ask questions to encourage comments
- Hashtags optional (1-3 if used, not as critical as other platforms)

BEST PRACTICES:
- Start with an engaging question or statement
- Share relatable stories or experiences
- Use "you" language to speak directly to audience
- Encourage tagging friends or sharing
- Include calls-to-action like "Comment below", "Share if you agree"
- Use line breaks for easy scanning
- Add value through tips, insights, or entertainment
- Consider ending with an emoji or question

ENGAGEMENT TACTICS:
- Fill-in-the-blank posts
- This or that questions
- Opinion-based questions
- Polls (if using poll feature)
- Share if you agree posts
- Tag a friend posts

FORMATTING:
- Use line breaks between thoughts
- Emojis to add personality
- Keep it scannable and easy to read
- First 2-3 lines are most important

AVOID:
- Excessive hashtags (this isn't Instagram)
- Overly long posts (500+ characters)
- Too formal or corporate language
- Link dropping without context
''',

    'pinterest': '''
PLATFORM: Pinterest
CHARACTER RANGE: 100-200 characters for titles, 400-500 for descriptions
STYLE: SEO-optimized, descriptive, and keyword-rich
TONE: Informative, inspirational, and actionable

REQUIREMENTS:
- Create both a compelling pin title and detailed description
- Front-load keywords for SEO (first 50-60 characters of description)
- Use natural language with strategic keyword placement
- Include a clear call-to-action
- Add relevant hashtags (3-5 recommended)
- Make content searchable and discoverable
- Focus on "how-to" or instructional language when applicable

PIN TITLE (100-200 chars):
- Include primary keyword
- Make it compelling and click-worthy
- Be specific about the value or benefit
- Use numbers when applicable (e.g., "10 Ways to...")
- Keep it under 100 characters for best display

PIN DESCRIPTION (400-500 chars):
- First 60 characters are critical (appear in feed)
- Include multiple relevant keywords naturally
- Describe what users will find/learn/get
- Use vertical bars | or bullets for lists
- Include branded keywords if applicable
- Add call-to-action at the end
- Mention specific features, benefits, or results

KEYWORD STRATEGY:
- Research and use high-volume search terms
- Include long-tail keywords
- Use related keywords throughout
- Think about how users search
- Include niche-specific terms

FORMATTING:
- Use line breaks in description
- Bullet points with | or •
- Numbers for lists
- Hashtags at the end
- CTA at the end

BEST PRACTICES:
- Think like a search query
- Be specific and descriptive
- Focus on value and benefits
- Include temporal keywords (2024, 2025, etc.)
- Use adjectives that describe (easy, quick, simple, best, etc.)

AVOID:
- Keyword stuffing
- Generic descriptions
- Missing calls-to-action
- Ignoring SEO best practices
''',
  };

  /// Gets the complete system prompt for a specific platform
  static String getSystemPrompt({
    required String platform,
    required String companyInfo,
    required String productInfo,
  }) {
    final platformKey = platform.toLowerCase();
    final platformGuide = platformInstructions[platformKey] ??
        platformInstructions['x']!; // Default to X if unknown platform

    return '''
You are an expert social media content creator specializing in ${_platformName(platformKey)} marketing.

COMPANY INFORMATION:
$companyInfo

PRODUCT/SERVICE INFORMATION:
$productInfo

$platformGuide

IMPORTANT GUIDELINES:
1. NEVER exceed the platform's character limits
2. Always maintain brand voice while adapting to platform style
3. Ensure content is engaging and drives the desired action
4. Use platform-specific features and best practices
5. Keep the target audience in mind
6. Make content authentic and valuable, not just promotional
7. Proofread for grammar and clarity
8. Ensure hashtags and emojis are relevant and appropriate

OUTPUT FORMAT:
Return ONLY the social media post content. Do not include:
- Explanations about what you did
- Meta-commentary about the post
- Alternative versions (unless specifically requested)
- Notes or suggestions (unless specifically requested)
- Quotation marks around the post

Simply return the ready-to-post content.
''';
  }

  /// Gets the prompt for image generation
  static String getImageGenerationPrompt({
    required String platform,
    required String contentDescription,
    required String companyInfo,
  }) {
    return '''
Create a marketing image for ${_platformName(platform)} with the following specifications:

CONTENT DESCRIPTION:
$contentDescription

COMPANY/BRAND CONTEXT:
$companyInfo

PLATFORM REQUIREMENTS:
${_getImagePlatformRequirements(platform)}

IMAGE STYLE:
- Professional and polished
- On-brand and visually appealing
- Optimized for ${_platformName(platform)}
- Clear focal point and composition
- Appropriate use of text (minimal overlay if any)
- High contrast and readable
- Modern and clean design

Generate an image that captures attention and aligns with the brand identity while meeting platform best practices.
''';
  }

  /// Gets platform-specific image requirements
  static String _getImagePlatformRequirements(String platform) {
    switch (platform.toLowerCase()) {
      case 'x':
        return '''
- Aspect ratio: 16:9 or 1:1
- Landscape format works well
- Text should be minimal and large
- High contrast for timeline visibility
''';
      case 'linkedin':
        return '''
- Aspect ratio: 1.91:1 (landscape) or 1:1 (square)
- Professional aesthetic
- Can include more text/data
- Clean, corporate-friendly design
''';
      case 'instagram':
        return '''
- Aspect ratio: 1:1 (square) or 4:5 (portrait)
- Highly visual and eye-catching
- Vibrant colors work well
- Minimal text overlay
- Instagram-aesthetic
''';
      case 'facebook':
        return '''
- Aspect ratio: 1.91:1 (landscape) or 1:1 (square)
- Versatile and engaging
- Works well with diverse content
- Clear and attention-grabbing
''';
      case 'pinterest':
        return '''
- Aspect ratio: 2:3 (vertical/portrait)
- Tall, vertical format essential
- Can include text overlays
- Detailed and visually rich
- Pin-worthy aesthetic
''';
      default:
        return '''
- Aspect ratio: 1:1 (square) recommended
- Professional and clean design
- Platform-optimized
''';
    }
  }

  /// Gets the display name for a platform
  static String _platformName(String platform) {
    switch (platform.toLowerCase()) {
      case 'x':
        return 'X (Twitter)';
      case 'linkedin':
        return 'LinkedIn';
      case 'instagram':
        return 'Instagram';
      case 'facebook':
        return 'Facebook';
      case 'pinterest':
        return 'Pinterest';
      default:
        return platform;
    }
  }

  /// Gets character limit for a platform
  static int getCharacterLimit(String platform) {
    switch (platform.toLowerCase()) {
      case 'x':
        return 280;
      case 'linkedin':
        return 3000; // LinkedIn supports up to 3000 but 1000-1500 is optimal
      case 'instagram':
        return 2200; // Instagram supports up to 2200 but shorter is better
      case 'facebook':
        return 63206; // Facebook supports very long posts but 100-400 is optimal
      case 'pinterest':
        return 500; // Pinterest description limit
      default:
        return 280;
    }
  }

  /// Validates if content is within platform limits
  static bool validateContentLength(String platform, String content) {
    final limit = getCharacterLimit(platform);
    return content.length <= limit;
  }

  /// Gets recommended character range for optimal engagement
  static Map<String, int> getRecommendedRange(String platform) {
    switch (platform.toLowerCase()) {
      case 'x':
        return {'min': 200, 'max': 280};
      case 'linkedin':
        return {'min': 1000, 'max': 1500};
      case 'instagram':
        return {'min': 200, 'max': 500};
      case 'facebook':
        return {'min': 100, 'max': 400};
      case 'pinterest':
        return {'min': 400, 'max': 500};
      default:
        return {'min': 100, 'max': 280};
    }
  }
}
