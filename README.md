# README

## Steps to Run the App
1. **Clone or Download** the repository to your local machine.
2. **Open the project** in Xcode (version 15 or later).
3. **Select an iOS 18 simulator** (or a device running iOS 18) from the scheme selector.
4. Press **Command + R** (Run) to build and launch the app.  
   - Make sure you have **iOS 18.0** SDK support in your Xcode environment.

## Focus Areas
I decided to really focus on and prioritize the UI. The app is fairly simple in terms of functionality, and there's not much data being worked with, so I had to make the most out of the limited information provided, such as the name, image, and country.  
To enhance user experience, I added a featured section, which highlights a specific cuisine dynamically, and incorporated sorting options that allow users to sort recipes alphabetically or by country. These features make the app more interactive and engaging while staying true to its simple design goals.

## Time Spent
- **Initial Development (About 5 hours)**: Focused on implementing the basic functionality, including:
  - Networking calls
  - Setting up the view models
  - Creating the initial UI

- **Ongoing Refinements (3-4 hours)**: Returned to the project over the next couple of weeks to:
  - Enhance the UI
  - Add sorting features
  - Adjust color accents and overall theme
  - Improve the overall user experience

- **Testing Section (1-2 hours)**: Dedicated time to:
  - Learn best practices for testing
  - Ensure the testing section was implemented correctly
  - Validate functionality with passing tests, which was incredibly rewarding

## Trade-offs and Decisions
One of the criteria for this project was to limit the app to a single main view. While I adhered to this by having one primary view, I made a deliberate decision to include a supplementary sheet to enhance the user experience.

The API provided additional links, such as:
- A large image for the recipe
- A source URL for the full recipe
- A YouTube URL for a video tutorial

So, rather than cluttering the main view, I opted to create a tappable detail sheet for each recipe. This sheet allows users to:
- Expand and view the recipe's image in detail
- See the recipe's name prominently displayed
- Access the YouTube video link directly
- Visit the full recipe site for further research

While the sheet isn't a "true" view in the context of navigation, it complements the app's single-view nature and makes better use of the data provided. This decision balanced adhering to the project's requirements while improving functionality and usability.

## Weakest Part of the Project
Overall, the project meets the stated requirements, but a few elements could be expanded or refined if it were intended for a larger, production-level app:

- **No UI Testing**:  
  In line with the project's instructions, I didn't implement UI or integration tests. For an App Store–ready app, I'd prioritize additional testing to ensure compatibility across various screen sizes and device types, reducing the risk of UI inconsistencies or layout issues.

- **Limited Feature Set**:  
  While the app demonstrates basic recipe browsing and a single main view, a fuller-scale app could benefit from:
  - **Favorite Folders**: Letting users group their favorite recipes (e.g., seafood, quick meals, etc.) for easy organization.
  - **User Profiles**: Providing a personal space to showcase favorite dishes, share collections, and see others’ collections.
  - **Recipe Creation**: Allowing users to upload their own dishes, complete with custom images, descriptions, and optional steps, transforming the app into a mini community for recipe sharing.

## Additional Information
- **Learning Curve for Testing**  
The testing portion was the most challenging aspect of this project for me. I’ve rarely used a dedicated testing file in my previous personal projects, so creating a thorough unit test suite in Xcode was a new experience. It took a fair amount of tutorials and documentation study to fully understand best practices. However, once I grasped the fundamentals, writing additional tests and refining them became much more straightforward.

**Seeing all tests pass felt incredibly rewarding.** Knowing the app was functioning properly was one thing, but having the tests confirm it gave me extra confidence in the code. I’ll definitely be incorporating more testing into my future side projects to maintain that level of assurance.

- **Environment & Deployment**  
  - The project targets **iOS 18.0** and was developed using **Xcode 15**.
  - Recipe data is fetched from a single remote endpoint. No advanced offline or error-correction logic was included, given the project’s scope.

## Contact
- **Email**: [jasinmarku@gmail.com](mailto:jasinmarku@gmail.com)
- **LinkedIn**: [https://www.linkedin.com/in/jasin-marku/](https://www.linkedin.com/in/jasin-marku/)
