from locust import HttpUser, task, between

class KanbanBoardLoadTest(HttpUser):
    wait_time = between(1, 5)  # Wait time between tasks (1-5 seconds)



    @task(3)  # Weighted task, executed twice as often as the next task
    def home(self):
        self.client.get("http://34.46.105.219")

    @task(2)
    def dashboard_1(self):
        self.client.get("http://34.46.105.219/2658eced-fd21-446a-8d7c-4896f0d423b3")

    @task(1)
    def dashboard_2(self):
        self.client.get("http://34.46.105.219/66b6b823-1f90-4227-aaa9-4f88f1950378")

