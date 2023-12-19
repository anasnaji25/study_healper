// To parse this JSON data, do
//
//     final geminiModel = geminiModelFromJson(jsonString);

import 'dart:convert';

GeminiModel geminiModelFromJson(String str) => GeminiModel.fromJson(json.decode(str));

String geminiModelToJson(GeminiModel data) => json.encode(data.toJson());

class GeminiModel {
    List<Candidate> candidates;

    GeminiModel({
        required this.candidates,
    });

    factory GeminiModel.fromJson(Map<String, dynamic> json) => GeminiModel(
        candidates: List<Candidate>.from(json["candidates"].map((x) => Candidate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "candidates": List<dynamic>.from(candidates.map((x) => x.toJson())),
    };
}

class Candidate {
    String output;

    Candidate({
        required this.output,
    });

    factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        output: json["output"],
       
    );

    Map<String, dynamic> toJson() => {
        "output": output,
    };
}

