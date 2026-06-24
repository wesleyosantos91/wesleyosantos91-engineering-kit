import http from 'k6/http';
import { check, sleep } from 'k6';

// Exemplo mínimo de teste de carga com k6 (sem dependências externas).
//
// Rodar:
//   k6 run kit/examples/k6/smoke.js
//
// Com o dashboard web embutido do k6 (não precisa de Grafana):
//   K6_WEB_DASHBOARD=true k6 run kit/examples/k6/smoke.js        # http://localhost:5665
//   K6_WEB_DASHBOARD_EXPORT=report.html k6 run kit/examples/k6/smoke.js   # gera report.html

export const options = {
  stages: [
    { duration: '15s', target: 10 },
    { duration: '30s', target: 10 },
    { duration: '15s', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const res = http.get('https://test.k6.io');
  check(res, { 'status é 200': (r) => r.status === 200 });
  sleep(1);
}
