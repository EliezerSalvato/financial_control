import axios from "axios";

const token = document.getElementsByName("csrf-token")[0].getAttribute("content");

const headers = {
  "X-Custom-Header": "foobar",
  "Accept": "application/json",
  "Content-Type": "application/json",
  "X-CSRF-Token": token,
}

const axiosInstance = axios.create({
  baseURL: "/api/v1/",
  // timeout: 3000,
  headers: headers
});

export const api = {
  get(endpoint, params = {}) {
    return axiosInstance.get(endpoint, { params });
  },
  post(endpoint, body) {
    return axiosInstance.post(endpoint, body);
  },
  put(endpoint, body) {
    return axiosInstance.put(endpoint, body);
  },
  delete(endpoint) {
    return axiosInstance.delete(endpoint);
  }
};
