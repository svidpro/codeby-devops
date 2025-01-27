<template>
  <v-app>
    <v-app-bar app color="black" dark>
      <v-toolbar-title>Todo List</v-toolbar-title>
    </v-app-bar>

    <v-main>
      <v-container>
        <v-row>
          <v-col cols="12" md="8" offset-md="2">
            <!-- Форма создания задачи -->
            <v-card class="mb-4">
              <v-card-title>Новая задача</v-card-title>
              <v-card-text>
                <v-form @submit.prevent="createTask">
                  <v-text-field
                    v-model="newTask.title"
                    label="Название"
                    required
                  ></v-text-field>
                  <v-textarea
                    v-model="newTask.description"
                    label="Описание"
                  ></v-textarea>
                  <v-select
                    v-model="newTask.status"
                    :items="statusOptions"
                    item-title="text"
                    item-value="value"
                    label="Статус"
                  ></v-select>
                  <v-menu
                    ref="dueDateMenu"
                    v-model="dueDateMenu"
                    :close-on-content-click="false"
                    transition="scale-transition"
                    offset-y
                    min-width="auto"
                  >
                    <template v-slot:activator="{ props }">
                      <v-text-field
                        v-model="formattedDueDate"
                        label="Срок выполнения"
                        prepend-icon="mdi-calendar"
                        readonly
                        v-bind="props"
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="newTask.due_date"
                      @update:model-value="dueDateMenu = false"
                    ></v-date-picker>
                  </v-menu>
                  <v-btn color="black" type="submit">Создать</v-btn>
                </v-form>
              </v-card-text>
            </v-card>

            <!-- Список задач -->
            <v-card>
              <v-card-title>
                Список задач
                <v-spacer></v-spacer>
                <v-select
                  v-model="statusFilter"
                  :items="statusOptions"
                  item-title="text"
                  item-value="value"
                  label="Фильтр по статусу"
                  class="ml-4"
                  style="max-width: 200px"
                  clearable
                ></v-select>
              </v-card-title>
              <v-card-text>
                <v-list>
                  <template v-for="(task, index) in filteredTasks" :key="task.id">
                    <v-list-item
                      :class="{ 'done': task.status === 'done' }"
                    >
                      <template v-slot:prepend>
                        <div class="d-flex flex-column">
                          <div class="text-h6">{{ task.title }}</div>
                          <div class="text-subtitle-2 description-text">{{ task.description }}</div>
                          <div class="text-subtitle-2">{{ task.due_date ? new Date(task.due_date).toLocaleString('ru-RU', {day: 'numeric', month: 'long', year: 'numeric', hour: '2-digit', minute: '2-digit'}) : '' }}</div>
                          <v-chip
                            :color="getStatusColor(task.status)"
                            class="mt-2"
                            small
                          >
                            {{ getStatusText(task.status) }}
                          </v-chip>
                        </div>
                      </template>

                      <template v-slot:append>
                        <div class="d-flex align-center">
                          <v-btn
                            icon
                            @click="editTask(task)"
                            color="black"
                            class="mr-2"
                          >
                            <v-icon>mdi-pencil</v-icon>
                          </v-btn>
                          <v-btn
                            icon
                            @click="deleteTask(task.id)"
                            color="error"
                          >
                            <v-icon>mdi-delete</v-icon>
                          </v-btn>
                        </div>
                      </template>
                    </v-list-item>
                    <v-divider
                      v-if="index < filteredTasks.length - 1"
                      :key="'divider-' + task.id"
                    ></v-divider>
                  </template>
                </v-list>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>

    <!-- Диалог редактирования -->
    <v-dialog v-model="editDialog" max-width="500px">
      <v-card>
        <v-card-title>Редактировать задачу</v-card-title>
        <v-card-text>
          <v-form @submit.prevent="updateTask">
            <v-text-field
              v-model="editedTask.title"
              label="Название"
              required
            ></v-text-field>
            <v-textarea
              v-model="editedTask.description"
              label="Описание"
            ></v-textarea>
            <v-select
              v-model="editedTask.status"
              :items="statusOptions"
              item-title="text"
              item-value="value"
              label="Статус"
            ></v-select>
            <v-menu
              ref="editDueDateMenu"
              v-model="editDueDateMenu"
              :close-on-content-click="false"
              transition="scale-transition"
              offset-y
              min-width="auto"
            >
              <template v-slot:activator="{ props }">
                <v-text-field
                  v-model="formattedEditDueDate"
                  label="Срок выполнения"
                  prepend-icon="mdi-calendar"
                  readonly
                  v-bind="props"
                ></v-text-field>
              </template>
              <v-date-picker
                v-model="editedTask.due_date"
                @update:model-value="editDueDateMenu = false"
              ></v-date-picker>
            </v-menu>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="closeEdit">Отмена</v-btn>
          <v-btn color="black" @click="updateTask">Сохранить</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-app>
</template>

<script>
import axios from 'axios';

const API_URL = process.env.VUE_APP_API_URL || 'http://localhost:8000';

export default {
  name: 'App',
  data() {
    return {
      tasks: [],
      newTask: {
        title: '',
        description: '',
        status: 'TODO',
        due_date: null
      },
      editDialog: false,
      editedTask: {
        id: null,
        title: '',
        description: '',
        status: 'TODO',
        due_date: null
      },
      statusFilter: null,
      dueDateMenu: false,
      editDueDateMenu: false,
      statusOptions: [
        { text: 'Запланировано', value: 'TODO' },
        { text: 'В процессе', value: 'IN_PROGRESS' },
        { text: 'Выполнено', value: 'DONE' }
      ]
    };
  },
  computed: {
    filteredTasks() {
      if (!this.statusFilter) return this.tasks;
      return this.tasks.filter(task => task.status === this.statusFilter);
    },
    formattedDueDate() {
      return this.formatDate(this.newTask.due_date);
    },
    formattedEditDueDate() {
      return this.formatDate(this.editedTask.due_date);
    }
  },
  methods: {
    formatDate(date) {
      if (!date) return '';
      return new Date(date).toLocaleDateString('ru-RU');
    },
    async fetchTasks() {
      try {
        const response = await axios.get(`${API_URL}/tasks/`, {
          params: { status: this.filterStatus }
        });
        this.tasks = response.data;
      } catch (error) {
        console.error('Error fetching tasks:', error);
      }
    },
    async createTask() {
      try {
        await axios.post(`${API_URL}/tasks/`, this.newTask);
        this.newTask = {
          title: '',
          description: '',
          status: 'TODO',
          due_date: null
        };
        await this.fetchTasks();
      } catch (error) {
        console.error('Error creating task:', error);
      }
    },
    async deleteTask(taskId) {
      try {
        await axios.delete(`${API_URL}/tasks/${taskId}`);
        await this.fetchTasks();
      } catch (error) {
        console.error('Error deleting task:', error);
      }
    },
    getStatusColor(status) {
      switch (status) {
        case 'TODO':
          return 'grey';
        case 'IN_PROGRESS':
          return 'orange';
        case 'DONE':
          return 'green';
        default:
          return 'grey';
      }
    },
    getStatusText(status) {
      switch (status) {
        case 'TODO':
          return 'Запланировано';
        case 'IN_PROGRESS':
          return 'В процессе';
        case 'DONE':
          return 'Выполнено';
        default:
          return status;
      }
    },
    editTask(task) {
      this.editedTask = {
        ...task,
        due_date: task.due_date ? new Date(task.due_date) : null
      };
      this.editDialog = true;
    },
    closeEdit() {
      this.editDialog = false;
      this.editedTask = {
        id: null,
        title: '',
        description: '',
        status: 'TODO',
        due_date: null
      };
    },
    async updateTask() {
      try {
        await axios.put(`${API_URL}/tasks/${this.editedTask.id}`, this.editedTask);
        await this.fetchTasks();
        this.closeEdit();
      } catch (error) {
        console.error('Error updating task:', error);
      }
    }
  },
  mounted() {
    this.fetchTasks();
  }
};
</script>

<style>
.done {
  opacity: 0.6;
}

.task-list {
  max-width: 800px;
  margin: 0 auto;
}

.description-text {
  white-space: normal;
  word-wrap: break-word;
  padding-right: 100px;
  margin: 8px 0;
  max-width: 600px;
}

.v-list-item {
  position: relative;
  padding: 16px;
  transition: all 0.3s ease;
  border-left: 3px solid transparent;
}

.v-list-item:hover {
  background-color: #f5f5f5;
  border-left: 3px solid #000;
}

.v-list-item .v-btn {
  position: relative;
  z-index: 1;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.v-list-item .v-btn:hover {
  opacity: 1;
}

.v-card {
  border: 1px solid #e0e0e0;
  box-shadow: none !important;
  transition: box-shadow 0.3s ease;
}

.v-card:hover {
  box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
}

.v-chip {
  font-weight: 500;
  letter-spacing: 0.5px;
}

.text-h6 {
  font-weight: 500;
  letter-spacing: 0.5px;
}

.v-btn {
  text-transform: none;
  letter-spacing: 0.5px;
}

.v-app-bar {
  border-bottom: 1px solid #e0e0e0;
}

.v-text-field .v-input__slot {
  border: 1px solid #e0e0e0 !important;
  transition: border-color 0.3s ease;
}

.v-text-field .v-input__slot:hover {
  border-color: #000 !important;
}

.v-select .v-input__slot {
  border: 1px solid #e0e0e0 !important;
  transition: border-color 0.3s ease;
}

.v-select .v-input__slot:hover {
  border-color: #000 !important;
}
</style>
