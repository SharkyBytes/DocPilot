# DocPilot

## 🩺 Next-Generation EMR with Conversational AI
DocPilot is a revolutionary Electronic Medical Records (EMR) application that leverages the power of conversational AI to transform doctor-patient interactions. Unlike traditional EMR systems from the 1990s that are complex and expensive, DocPilot listens to consultations in real-time, automatically extracts medical information, and generates prescriptions instantly - saving time, reducing errors, and improving patient care.

## Architecture Diagram of the DocPilot

![image](https://github.com/user-attachments/assets/229555c2-a60c-4906-ba48-cb1d6d62ec77)


If you want a closer look at the architecture, check the [Architecture file](https://app.eraser.io/workspace/v3JYYLaQzkBurIUdBMqN?origin=share) 



## **Features**  
✅ **Doctor & Patient Dashboards** – Manage appointments and consultations with ease.  
✅ **Real-time Transcription** – WhisperX-powered conversation processing.  
✅ **Speaker Diarization** – Identifies doctor and patient using Pyannote.  
✅ **AI-powered Prescription Generation** – Extracts key medical details and formats prescriptions.  
✅ **Digital Signing** – Enables doctors to sign prescriptions securely.  
✅ **Appointment Scheduling** – Book and manage patient consultations.  
✅ **Medical History Storage** – Access past prescriptions and records.  
✅ **Cross-platform Accessibility** – Works on both web and mobile.  
✅ **Offline Functionality** – Ensures usability in remote areas.  
✅ **Analytics Dashboard** – Provides insights for better healthcare management.  


## 🎨 Figma Designs

To ensure an intuitive and seamless user experience, I have designed the entire workflow of DocPilot in Figma. The designs incorporate all the proposed and required features to provide a smooth interaction for both doctors and patients. These prototypes serve as a blueprint for development, and I will do my best to translate them into fully functional and efficient code.

If you want to take a closer look at the designs, check out this [Figma Design](https://www.figma.com/design/MMwaRW41sXn69AIrelM60R/DocPilot_?node-id=0-1&t=8qvTywXeZKf744eX-1).

### Patient User Flow

![image](https://github.com/user-attachments/assets/574377d6-06d6-446c-8f2a-ae12ded061fb)

### Doctor User Flow

![image](https://github.com/user-attachments/assets/64b71fcb-201b-4c25-9d03-ed70fb1a7bc1)

### Working Prototype

Patient Flow Prototype


https://github.com/user-attachments/assets/f4e7c267-fad7-438d-9927-2969dd3ba07b

Doctor Flow Prototype

https://github.com/user-attachments/assets/9000a5e7-7c17-47a9-9752-55416ea15dbe


## Tech Stack

### Frontend
- Flutter for cross-platform (iOS/Android) compatibility

### Backend
- Appwrite for authentication, database, and storage

### AI Components
- WhisperX for accurate speech-to-text transcription
- PyAnnote for speaker diarization
- Gemini AI for medical information extraction and prescription generation

### State Management
- Provider package

### Real-time Communication
- WebRTC for video consultations


## **🔄 Workflow**  

### **Doctor Workflow**  
➡️ Logs into the system  
➡️ Accesses dashboard to view appointments  
➡️ Initiates consultation with the patient  
➡️ **DocPilot** records and processes the conversation  
➡️ AI extracts medical information and generates a prescription  
➡️ Doctor reviews, edits if needed, and digitally signs it  
➡️ Prescription is saved to patient records and can be printed  

### **Patient Workflow**  
➡️ Logs into the portal  
➡️ Books an appointment with a preferred doctor  
➡️ Joins video consultation at the scheduled time  
➡️ Receives a digital copy of the prescription  
➡️ Accesses medical history and past prescriptions 



## **📌 Roadmap**  
➡️ **Basic authentication and user management**  
➡️ **Doctor and patient dashboards**  
➡️ **Real-time transcription integration**  
➡️ **AI-powered prescription generation**  
➡️ **Digital signing capability**  
➡️ **Appointment scheduling system**  
➡️ **Medical history storage and retrieval**  
➡️ **Mobile and web responsive interfaces**  
➡️ **Offline functionality for remote areas**  
➡️ **Analytics dashboard for healthcare insights**  


## Project Structure

```
lib/
├── core/
│   ├── models/
│   ├── theme/
│   └── widgets/
├── presentation/
│   ├── auth/
│   ├── dashboard/
│   └── splash_screen.dart
└── providers/
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## UI Design

The app features a modern and clean UI design with:

- Custom animations
- Gradient colors
- Responsive layouts
- Consistent color scheme
- Modern input fields and buttons

## Next Steps

- Backend integration
- API services
- Local data persistence
- Push notifications 
