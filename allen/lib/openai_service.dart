import 'dart:convert';

import 'package:allen/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService 
{
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async
  {
    try
    {
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');
      final headers = <String, String> {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKEY',
      };
      final body = jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [{
            'role': 'user',
            'content':
                'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
          }],
      });

      final response = await http.post(url, headers: headers, body: body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200)
      {
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.toUpperCase().replaceAll(".", "").trim(); //make the string UpperCase and remove . and white space
      
        if (content == "YES")
        {
          return await dallEAPI(prompt);
        }
        else 
        {
          return await chatGPTAPI(prompt);
        }
      }

      return 'An internal error ocurred.';
    }
    catch(e)
    {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async 
  {
    messages.add({
      'role': 'user',
      'content': prompt
    });

    try 
    {
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');
      final headers = <String, String> {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKEY'
      };
      final body = jsonEncode(
        {
          'model': 'gpt-3.5-turbo',
          'messages': messages
        }
      );

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200)
      {
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content
        });

        return content;
      }

      return 'An internal error ocurred.';
    }
    catch(e)
    {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async 
  {
    messages.add({
      'role': 'user',
      'content': prompt
    });

    try
    {
      final url = Uri.parse('https://api.openai.com/v1/images/generations');
      final headers = <String, String> {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKEY'
      };
      final body = jsonEncode({
        'prompt': prompt,
        'n': 1
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200)
      {
          String imageUrl = jsonDecode(response.body)['data'][0]['url'];
          imageUrl = imageUrl.trim();

          messages.add({
            'role': 'assistant',
            'content': imageUrl
          });

          return imageUrl;
      }

      return 'An internal error ocurred';
    }
    catch(e)
    {
      return e.toString();
    }
  }
}
