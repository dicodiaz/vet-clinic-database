CREATE TABLE medical_histories(
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  admitted_at TIMESTAMP NOT NULL,
  patient_id INT NOT NULL,
  status VARCHAR(100) NOT NULL
);

CREATE INDEX idx_medical_histories_patient_id ON medical_histories(patient_id);

CREATE TABLE treatments(
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  TYPE VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE treatments_history(
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  medical_history_id INT NOT NULL REFERENCES medical_histories(id),
  treatment_id INT NOT NULL REFERENCES treatments(id)
);

CREATE INDEX idx_treatments_history_medical_history_id ON treatments_history(medical_history_id);
CREATE INDEX idx_treatments_history_treatment_id ON treatments_history(treatment_id);

CREATE TABLE patients(
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL
);

ALTER TABLE medical_histories ADD CONSTRAINT fk_medical_histories_patients FOREIGN KEY (patient_id) REFERENCES patients(id);

CREATE TABLE invoices(
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  total_amount DECIMAL NOT NULL,
  generated_at TIMESTAMP NOT NULL,
  payed_at TIMESTAMP NOT NULL,
  medical_history_id INT NOT NULL REFERENCES medical_histories(id)
);

CREATE INDEX idx_invoices_medical_history_id ON invoices(medical_history_id);

CREATE TABLE invoice_items(
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  unit_price DECIMAL NOT NULL,
  quantity INT NOT NULL,
  total_price DECIMAL NOT NULL,
  invoice_id INT NOT NULL REFERENCES invoices(id),
  treatment_id INT NOT NULL REFERENCES treatments(id)
);

CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX idx_invoice_items_treatment_id ON invoice_items(treatment_id);
