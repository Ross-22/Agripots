class AIConfig {
  // Add your DeepSeek API key here
  static const String apiKey = 'sk-d562dded20b84bb5985ad1fa61bb6804';

  // AI Model Configuration
  static const String model = 'deepseek-chat';
  static const double temperature = 0.5;
  static const int maxTokens = 1000;

  // System prompt that defines the AI's personality and behavior
  static const String systemPrompt = """
  You are AgriBot, a helpful AI assistant for the AgriPots app. 
  Your role is to assist users with agricultural advice, plant care tips, 
  and gardening questions. Be friendly, informative, and professional.
  
  Key guidelines:
  - Provide accurate and practical agricultural advice
  - Keep responses concise and easy to understand
  - Be encouraging and positive
  - If you don't know something, say so rather than making up information
  - For complex questions, break down the information into clear steps
  """;

  // API Endpoint
  static const String apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  // Headers for the API request
  static Map<String, String> get headers => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };
}
